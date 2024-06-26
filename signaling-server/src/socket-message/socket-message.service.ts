import { Injectable, Logger } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { WebSocket } from 'ws';
import { RoomService } from '../room/room.service';
import { SocketMessageDTO, TypeSocketMessage } from './dto/socket.dto';
import { RoomDTO } from 'room/dto/room.dto';
import { RoomSocketService } from 'room-socket/room-socket.service';

@Injectable()
export class SocketMessageService {
  constructor(
    private roomService: RoomService,
    private roomSocketService: RoomSocketService,
  ) {}
  private logger = new Logger(SocketMessageService.name);

  //handle message
  async handleMessage(client: WebSocket, message: string) {
    this.logger.log(`handleMessage clientId ${client.id} message ${message}`);
    try {
      const messageJSON: SocketMessageDTO = JSON.parse(message);
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
          break;
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
    let roomEmpty = await this.roomService.findRoomEmpty(
      client.id,
      roomIdJoined,
    );
    if (roomEmpty) {
      await this.roomService.addUserInRoom(roomEmpty.roomId, client);
    } else {
      roomEmpty = await this.roomService.createNewRoom(client);
    }

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
      return null;
    }

    //send stop room
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.stop,
      data: {
        roomId: userInRoom.roomId,
      },
    });
    //send to client another
    const clientIdAnother = await this.sendMessageForAnotherInRoom(
      client,
      userInRoom.roomId,
      JSON.stringify(socketMessageDTO),
    );
    // remove room
    await this.roomService.removeRoom(userInRoom.roomId);

    if (!clientIdAnother) return null;
    // join new room for client another
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
    await this.handleJoinRoom(client, roomIdNew);
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

  async sendMessageForAnotherInRoom(
    client: WebSocket,
    roomId: string,
    message: string,
  ) {
    const clientIdAnother =
      await this.roomSocketService.findClientAnotherInSocketMessageRooms(
        roomId,
        client.id,
      );
    if (clientIdAnother) {
      this.logger.log(
        `sendMessageForAnotherInRoom in room ${roomId} to clientId ${clientIdAnother.id} message ${JSON.stringify(message)}`,
      );
      this.sendMessageForClient(clientIdAnother, message);
      return clientIdAnother;
    }
    return null;
  }
}
