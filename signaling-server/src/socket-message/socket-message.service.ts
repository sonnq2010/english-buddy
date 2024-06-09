import { Injectable, Logger } from '@nestjs/common';
import { Room, RoomDTO } from 'room/dto/room.dto';
import { v4 as uuidv4 } from 'uuid';
import { Server, WebSocket } from 'ws';
import { RoomService } from '../room/room.service';
import { SocketMessageDTO, TypeSocketMessage } from './dto/socket.dto';

@Injectable()
export class SocketMessageService {
  constructor(private roomService: RoomService) {}

  private readonly cats: any[] = [];
  private logger = new Logger(SocketMessageService.name);
  socketMessageRooms: Room[] = [];

  //handle message
  async handleMessage(client: WebSocket, message: string) {
    this.logger.log(`handleMessage clientId ${client.id} message ${message}`);
    try {
      const messageJSON = JSON.parse(message);
      switch (messageJSON.type) {
        case TypeSocketMessage.join:
          await this.handleJoinRoom(client);
          break;
        case TypeSocketMessage.stop:
          await this.handleLeaveRoom(client);
          break;
        case TypeSocketMessage.skip:
          await this.handleSkipRoom(client, messageJSON.data.roomId);
          break;
        case TypeSocketMessage.offer:
          await this.handleOffer(client, messageJSON);
          break;
        case TypeSocketMessage.candidates:
          await this.handleCandidates(client, messageJSON);
          break;
        case TypeSocketMessage.answer:
          await this.handleAnswer(client, messageJSON);
        case TypeSocketMessage.chat:
          await this.handleChatMessage(client, messageJSON);
          break;
        default:
          break;
      }
    } catch (error) {
      this.logger.error(`handleMessage error: ${error}`);
    }
  }

  handleClientConnect(client: WebSocket) {
    try {
      const clientId: string = uuidv4();
      this.logger.log(`clientConnect clientId generated: ${clientId}`);
      client.id = clientId;
      const socketMessageDTO = new SocketMessageDTO({
        type: TypeSocketMessage.id,
        data: {
          clientId,
        },
      });
      this.logger.log(
        `generateClientId send socket: ${JSON.stringify(socketMessageDTO)}`,
      );
      this.sendMessageForClient(client, JSON.stringify(socketMessageDTO));
    } catch (error) {
      this.logger.error(`clientConnect error: ${error}`);
    }
  }

  async handleJoinRoom(
    client: WebSocket,
    roomIdJoined?: string,
  ): Promise<string> {
    this.logger.log(
      `joinRoom clientId ${client.id}, roomIdJoined ${roomIdJoined}`,
    );
    let roomEmpty: RoomDTO = await this.roomService.findRoomEmpty(
      client,
      roomIdJoined,
    );
    if (roomEmpty?.user1) {
      const checkUserActiveInRoom = await this.checkUserActiveInRoom(
        roomEmpty.user1,
        roomEmpty.roomId,
      );
      if (!checkUserActiveInRoom) {
        return this.handleJoinRoom(client, roomIdJoined);
      }
      //update room
      roomEmpty = new RoomDTO({
        roomId: roomEmpty.roomId,
        user2: client.id,
      });
      await this.roomService.updateRoom(roomEmpty);
    }
    if (!roomEmpty) {
      const roomDTO = new RoomDTO({
        roomId: uuidv4(),
        user1: client.id,
      });
      roomEmpty = await this.roomService.createNewRoom(roomDTO);
      if (!roomEmpty) {
        return;
      }
    }
    //join room in redis
    await this.roomService.addClientToRoomRedis(roomEmpty.roomId, client.id);
    //add client to socket message rooms
    this.addClientToSocketMessageRooms(client, roomEmpty.roomId);

    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.join,
      data: {
        roomId: roomEmpty.roomId,
      },
    });
    //send message to client
    this.sendMessageForClient(client, JSON.stringify(socketMessageDTO));
    return roomEmpty.roomId;
  }

  async handleLeaveRoom(client: WebSocket): Promise<string> {
    this.logger.log(`leaveRoom clientId ${client.id} leave room`);
    const userInRoom: RoomDTO = await this.roomService.findUserInRoom(
      client.id,
    );
    if (!userInRoom) {
      return;
    }
    const roomUpdateDTO = new RoomDTO({
      roomId: userInRoom.roomId,
      user1: null,
      user2: null,
      isDeleted: true,
    });

    await this.roomService.updateRoom(roomUpdateDTO);
    //remove user in room in redis
    this.roomService.removeClientFromRoomRedis(userInRoom.roomId, client.id);
    //remove client from socket message rooms
    this.removeClientFromSocketMessageRooms(client, userInRoom.roomId);
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.stop,
      data: {
        roomId: userInRoom.roomId,
      },
    });
    this.sendMessageForAnotherInRoom(
      client,
      userInRoom.roomId,
      JSON.stringify(socketMessageDTO),
    );

    // find new room for client another
    const clientIdAnother = await this.findClientAnotherInSocketMessageRooms(
      userInRoom.roomId,
      client.id,
    );
    if (!clientIdAnother) return null;
    this.roomService.removeClientFromRoomRedis(
      userInRoom.roomId,
      clientIdAnother.id,
    );
    const roomIdNew = await this.handleJoinRoom(
      clientIdAnother,
      userInRoom.roomId,
    );
    return roomIdNew;
  }

  async handleSkipRoom(client: WebSocket, roomId: string) {
    this.logger.log(`skipRoom clientId ${client.id} skip room`);
    //send skip room
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.skip,
      data: {
        roomId,
      },
    });

    await this.sendMessageForAnotherInRoom(
      client,
      roomId,
      JSON.stringify(socketMessageDTO),
    );
    const roomIdNew: string = await this.handleLeaveRoom(client);
    //send to another client in message
    this.handleJoinRoom(client, roomIdNew);
  }

  // handleOffer
  async handleOffer(client: WebSocket, message: SocketMessageDTO) {
    this.logger.log(
      `handleOffer clientId ${client.id} message ${JSON.stringify(message)}`,
    );
    const { roomId, offer } = message.data;
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.offer,
      data: {
        roomId,
        offer,
      },
    });
    await this.sendMessageForAnotherInRoom(
      client,
      roomId,
      JSON.stringify(socketMessageDTO),
    );
  }

  //handel Candidates
  async handleCandidates(client: WebSocket, message: SocketMessageDTO) {
    this.logger.log(
      `handleCandidates clientId ${client.id} message ${JSON.stringify(
        message,
      )}`,
    );
    const { roomId, candidates } = message.data;
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.candidates,
      data: {
        roomId,
        candidates,
      },
    });
    await this.sendMessageForAnotherInRoom(
      client,
      roomId,
      JSON.stringify(socketMessageDTO),
    );
  }

  //handleAnswer
  async handleAnswer(client: WebSocket, message: SocketMessageDTO) {
    this.logger.log(
      `handleAnswer clientId ${client.id} message ${JSON.stringify(message)}`,
    );
    const { roomId, answer } = message.data;
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.answer,
      data: {
        roomId,
        answer,
      },
    });
    await this.sendMessageForAnotherInRoom(
      client,
      roomId,
      JSON.stringify(socketMessageDTO),
    );
  }

  //handleChatMessage
  async handleChatMessage(client: WebSocket, socketMessage: SocketMessageDTO) {
    this.logger.log(
      `handleChatMessage clientId ${client.id} message ${JSON.stringify(socketMessage)}`,
    );
    const { roomId, message } = socketMessage.data;
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.chat,
      data: {
        roomId,
        message,
      },
    });
    await this.sendMessageForAnotherInRoom(
      client,
      roomId,
      JSON.stringify(socketMessageDTO),
    );
  }

  async checkUserActiveInRoom(
    userId: string,
    roomId: string,
  ): Promise<boolean> {
    this.logger.log(
      `checkUserActiveInRoom clientId ${userId} in roomId ${roomId}`,
    );
    const checkUserActiveInSocketMessageRooms =
      this.checkClientIdInSocketMessageRooms(roomId, userId);
    if (checkUserActiveInSocketMessageRooms) {
      return true;
    }
    // delete user in room redis
    await this.roomService.removeClientFromRoomRedis(roomId, userId);
    // delete user in socket message rooms
    this.removeClientFromSocketMessageRooms(userId, roomId);
    // update room
    const roomDTO = new RoomDTO({
      roomId,
      user1: null,
      user2: null,
      isDeleted: true,
    });
    await this.roomService.updateRoom(roomDTO);
    return false;
  }

  async findClientAnotherInRoomRedis(
    server: Server,
    client: WebSocket,
    roomId: string,
  ): Promise<WebSocket> {
    const clientIds = await this.roomService.getClientsInRoomRedis(roomId);
    const clientIdAnother = clientIds.find((id) => id !== client.id);
    this.logger.log(`clientIdAnother ${JSON.stringify(clientIdAnother)}`);
    for (const wsClient of server.clients) {
      if (wsClient.id === clientIdAnother) {
        return wsClient;
      }
    }
    return null;
  }

  async sendMessageForAnotherInRoom(
    client: WebSocket,
    roomId: string,
    message: string,
  ) {
    const clientIdAnother = await this.findClientAnotherInSocketMessageRooms(
      roomId,
      client.id,
    );
    if (clientIdAnother) {
      this.logger.log(
        `sendMessageForAnotherInRoom in room ${roomId} to clientId ${clientIdAnother.id} message ${JSON.stringify(message)}`,
      );
      this.sendMessageForClient(clientIdAnother, message);
    }
  }

  async sendMessageForClient(client: WebSocket, message: string) {
    try {
      this.logger.log(
        `sendMessageForClient clientId ${client.id} message ${message}`,
      );
      client.send(message);
    } catch (error) {
      this.logger.error(`sendMessageForClient error: ${error}`);
    }
  }

  addClientToSocketMessageRooms(client: WebSocket, roomId: string) {
    this.logger.log(
      `addClientToSocketMessageRooms clientId ${client.id} in roomId ${roomId}`,
    );
    if (!this.socketMessageRooms[roomId]) {
      this.socketMessageRooms[roomId] = new Set();
    }
    this.socketMessageRooms[roomId].add(client);
  }

  findClientAnotherInSocketMessageRooms(roomId: string, clientId: string) {
    this.logger.log(
      `findClientAnotherInSocketMessageRooms clientId ${clientId} in roomId ${roomId}`,
    );
    if (this.socketMessageRooms[roomId]) {
      for (const client of this.socketMessageRooms[roomId]) {
        if (client.id !== clientId) {
          return client;
        }
      }
    }
    return null;
  }

  checkClientIdInSocketMessageRooms(roomId: string, clientId: string) {
    this.logger.log(
      `checkClientIdInSocketMessageRooms clientId ${clientId} in roomId ${roomId}`,
    );
    if (this.socketMessageRooms[roomId]) {
      for (const client of this.socketMessageRooms[roomId]) {
        if (client.id === clientId) {
          return true;
        }
      }
    }
    return false;
  }

  removeClientFromSocketMessageRooms(client: WebSocket, roomId: string) {
    this.logger.log(
      `removeClientFromSocketMessageRooms clientId ${client.id} in roomId ${roomId}`,
    );
    if (this.socketMessageRooms[roomId]) {
      this.socketMessageRooms[roomId].delete(client);
      if (this.socketMessageRooms[roomId].size === 0) {
        this.removeSocketMessageRoom(roomId);
      }
    }
  }

  removeSocketMessageRoom(roomId: string) {
    this.logger.log(`removeSocketMessageRooms roomId ${roomId}`);
    delete this.socketMessageRooms[roomId];
  }
}
