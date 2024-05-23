import { Injectable, Logger } from '@nestjs/common';
import { uuid } from 'uuidv4';
import { WebSocket } from 'ws';
import { SocketMessageDTO, TypeSocketMessage, DataSocketMessageDTO } from './dto/socket.dto';
import { RoomService } from '../room/room.service';
import { Room } from '../room/dto/room.dto';



@Injectable()
export class SocketMessageService {
  constructor(private roomService: RoomService) {}

  private readonly cats: any[] = [];
  private logger = new Logger(SocketMessageService.name);

  generateClientId(client: WebSocket) {
    const clientId: string = uuid();
    this.logger.log(`generateClientId clientId generated: ${clientId}`);
    client.id = clientId;
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.id,
      data: {
        clientId
      }
    });
    this.logger.log(`generateClientId send socket: ${JSON.stringify(socketMessageDTO)}`);
    client.send(JSON.stringify(socketMessageDTO));
  }

  async joinRoom(client: WebSocket, rooms: Room, roomIdJoined?: string) {
    const roomEmpty = await this.roomService.findRoomEmpty(client, rooms, roomIdJoined);
    const socketMessageDTO = new SocketMessageDTO({
      type: TypeSocketMessage.join,
      data: {
        roomId: roomEmpty
      }
    });
    this.logger.log(`joinRoom send socket: ${JSON.stringify(socketMessageDTO)}`);
    client.send(JSON.stringify(socketMessageDTO))
    this.sendMessageForAnotherInRoom(client, rooms, roomEmpty, JSON.stringify({type: 'text', data: `user ${client.id} joined room`}));
  }

  async leaveRoom(client: WebSocket, rooms: Room) {
    const userInRoom = await this.roomService.findUserInRoom(client.id);
    if(!userInRoom) {
      return
    }
    const roomId = userInRoom.roomId;
    let user1 = userInRoom.user1;
    let user2 = userInRoom.user2;
    if(user1 != client.id) {
      user2 = null
    } else {
      user1 = null;
    }

    await this.roomService.removeUserInRoom(roomId, user1, user2);
    if (rooms[roomId]) {
      rooms[roomId].delete(client);
      if (rooms[roomId].size === 0) {
        delete rooms[roomId];
      }
    }
    this.sendMessageForAnotherInRoom(client, rooms, roomId, JSON.stringify({type: 'text', data: `user ${client.id} out room`}));
    return roomId;
  }

  async skipRoom(client: WebSocket, rooms: Room) {
    const roomIdJoined = await this.leaveRoom(client, rooms);
    this.joinRoom(client, rooms, roomIdJoined);
  }

  async sendMessageForAnotherInRoom(client: WebSocket, rooms: Room, roomId: string, message: string) {
    const userClientAnother = this.findInSet(client, rooms[roomId])

    if(userClientAnother) {
      userClientAnother.send(message);
    }
  }

  findInSet(pred, set) { 
    if(!set) return null;
    for (let item of set) if(pred.id != item.id) return item;
  }
}