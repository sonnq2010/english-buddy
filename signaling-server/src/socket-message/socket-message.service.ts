import { Injectable, Logger } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { Server, WebSocket } from 'ws';
import { RoomService } from '../room/room.service';
import { SocketMessageDTO, TypeSocketMessage } from './dto/socket.dto';

@Injectable()
export class SocketMessageService {
  constructor(private roomService: RoomService) {}

  private readonly cats: any[] = [];
  private logger = new Logger(SocketMessageService.name);

  generateClientId(client: WebSocket) {
    const clientId: string = uuidv4();
    this.logger.log(`generateClientId clientId generated: ${clientId}`);
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
    client.send(JSON.stringify(socketMessageDTO));
  }

  async joinRoom(client: WebSocket, server: Server, roomIdJoined?: string) {
    this.logger.log(
      `joinRoom clientId ${client.id}, roomIdJoined ${roomIdJoined}`,
    );
    const roomEmpty = await this.roomService.findRoomEmpty(
      client,
      roomIdJoined,
    );
    //join room in redis
    await this.roomService.addClientToRoom(roomEmpty, client.id);

    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.join,
      data: {
        roomId: roomEmpty,
      },
    });
    this.logger.log(
      `joinRoom send socket: ${JSON.stringify(socketMessageDTO)}`,
    );
    client.send(JSON.stringify(socketMessageDTO));
    return roomEmpty;
    // this.sendMessageForAnotherInRoom(
    //   server,
    //   client,
    //   roomEmpty,
    //   JSON.stringify({ type: 'text', data: `user ${client.id} joined room` }),
    // );
  }

  async leaveRoom(client: WebSocket, server: Server) {
    this.logger.log(`leaveRoom clientId ${client.id} leave room`);
    const userInRoom = await this.roomService.findUserInRoom(client.id);
    if (!userInRoom) {
      return;
    }
    const roomIdJoined = userInRoom.roomId;
    const user1 = null;
    const user2 = null;

    await this.roomService.removeUserInRoom(roomIdJoined, user1, user2);
    //remove user in room in redis
    this.roomService.removeClientFromRoom(roomIdJoined, client.id);
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.stop,
      data: {
        roomId: roomIdJoined,
      },
    });
    this.sendMessageForAnotherInRoom(
      server,
      client,
      roomIdJoined,
      JSON.stringify(socketMessageDTO),
    );
    // find new room for client another
    const clientIdAnother = await this.findClientAnotherInRoom(
      server,
      client,
      roomIdJoined,
    );
    if (!clientIdAnother) return null;
    this.roomService.removeClientFromRoom(roomIdJoined, clientIdAnother.id);
    const roomIdNew = await this.joinRoom(
      clientIdAnother,
      server,
      roomIdJoined,
    );
    return roomIdNew;
  }

  async skipRoom(client: WebSocket, server: Server, roomId: string) {
    this.logger.log(`skipRoom clientId ${client.id} skip room`);
    //send skip room
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.skip,
      data: {
        roomId,
      },
    });

    await this.sendMessageForAnotherInRoom(
      server,
      client,
      roomId,
      JSON.stringify(socketMessageDTO),
    );
    const roomIdNew = await this.leaveRoom(client, server);
    //send to another client in message
    this.joinRoom(client, server, roomIdNew);
  }

  async findClientAnotherInRoom(
    server: Server,
    client: WebSocket,
    roomId: string,
  ): Promise<WebSocket> {
    const clientIds = await this.roomService.getClientsInRoom(roomId);
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
    server: Server,
    client: WebSocket,
    roomId: string,
    message: string,
  ) {
    const clientIdAnother = await this.findClientAnotherInRoom(
      server,
      client,
      roomId,
    );
    if (clientIdAnother) {
      this.logger.log(
        `sendMessageForAnotherInRoom in room ${roomId} to clientId ${clientIdAnother.id} message ${JSON.stringify(message)}`,
      );
      clientIdAnother.send(message);
    }
  }
}
