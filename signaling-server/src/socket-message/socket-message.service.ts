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
    this.sendMessageForAnotherInRoom(
      server,
      client,
      roomEmpty,
      JSON.stringify({ type: 'text', data: `user ${client.id} joined room` }),
    );
  }

  async leaveRoom(client: WebSocket, server: Server) {
    this.logger.log(`leaveRoom clientId ${client.id} leave room`);
    const userInRoom = await this.roomService.findUserInRoom(client.id);
    if (!userInRoom) {
      return;
    }
    const roomId = userInRoom.roomId;
    const user1 = userInRoom.user1 === client.id ? null : userInRoom.user1;
    const user2 = userInRoom.user2 === client.id ? null : userInRoom.user2;

    await this.roomService.removeUserInRoom(roomId, user1, user2);
    //remove user in room in redis
    this.roomService.removeClientFromRoom(roomId, client.id);
    this.sendMessageForAnotherInRoom(
      server,
      client,
      roomId,
      JSON.stringify({ type: 'text', data: `user ${client.id} out room` }),
    );
    return roomId;
  }

  async skipRoom(client: WebSocket, server: Server) {
    this.logger.log(`skipRoom clientId ${client.id} skip room`);
    const roomIdJoined = await this.leaveRoom(client, server);
    this.joinRoom(client, server, roomIdJoined);
  }

  async sendMessageForAnotherInRoom(
    server: Server,
    client: WebSocket,
    roomId: string,
    message: string,
  ) {
    const clientIds = await this.roomService.getClientsInRoom(roomId);
    const clientIdAnother = clientIds.find((id) => id !== client.id);
    this.logger.log(`clientIdAnother ${JSON.stringify(clientIdAnother)}`);
    if (clientIdAnother) {
      server.clients.forEach((client: WebSocket) => {
        if (client.id === clientIdAnother) {
          client.send(message);
        }
      });
    }
  }
}
