import { Injectable, Logger } from '@nestjs/common';
import { Room } from 'room/dto/room.dto';
import { WebSocket } from 'ws';

@Injectable()
export class RoomSocketService {
  constructor() {}
  private readonly logger = new Logger(RoomSocketService.name);
  socketMessageRooms: Room = {};

  addClientToSocketMessageRooms(roomId: string, client: WebSocket) {
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

  removeSocketMessageRoom(roomId: string) {
    this.logger.log(`removeSocketMessageRooms roomId ${roomId}`);
    if (this.socketMessageRooms[roomId]) delete this.socketMessageRooms[roomId];
  }
}
