import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateRoomDTO } from './dto/room.dto';
import { uuid } from 'uuidv4';
import { WebSocket } from 'ws';
import { Room } from './dto/room.dto';

@Injectable()
export class RoomService {
  constructor(private prisma: PrismaService) {}

  create(createRoomDTO: CreateRoomDTO) {
    return this.prisma.room.create({data: createRoomDTO});
  }

  async findRoomEmpty(client: WebSocket, rooms: Room, roomIdJoined?: string): Promise<string> {
    const roomEmpty = await this.prisma.room.findFirst({where: {
      OR: [
        { user1: null, NOT: { user2: null }, isDeleted: false },
        { user2: null, NOT: { user1: null }, isDeleted: false },
      ],
      NOT: {
        roomId: roomIdJoined
      }
    }});

    if(roomEmpty) {
      const roomId = roomEmpty.roomId;
      const user = {
        user1: '',
        user2: ''
      }
      if(roomEmpty.user1) {
        user.user1 = roomEmpty.user1;
        user.user2 = client.id;
      } else {
        user.user2 = roomEmpty.user2;
        user.user1 = client.id;
      }

      await this.prisma.room.update({
        where: {
          roomId
        },
        data: {
          ...user
        }
      })
      if(!rooms[roomId]) {
        rooms[roomId] = new Set();
      }
      rooms[roomId].add(client);
      return roomId;
    }

    const roomId = uuid();
    const user1 = client.id;
    
    const createRoomDTO: CreateRoomDTO = {
      roomId,
      user1
    }

    await this.create(createRoomDTO);
    rooms[roomId] = new Set();
    rooms[roomId].add(client);
    return roomId;
  }

  async findUserInRoom(userId: string) {
    const userInRoom = await this.prisma.room.findFirst({
      where: {
        OR: [
          { user1: userId, isDeleted: false },
          { user2: userId, isDeleted: false },
        ]
      }
    });
    return userInRoom;
  }

  async removeUserInRoom(roomId: string, user1: string, user2: string) {
    await this.prisma.room.update({
      where: {
        roomId,
      },
      data: {
        user1,
        user2,
      }
    })
  }
}


