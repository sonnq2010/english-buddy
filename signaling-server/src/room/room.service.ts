import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateRoomDTO } from './dto/room.dto';
import { uuid } from 'uuidv4';
import { WebSocket } from 'ws';
import { Room } from './dto/room.dto';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class RoomService {
  constructor(
    private prisma: PrismaService,
    private readonly redisService: RedisService,
  ) {}

  private logger = new Logger(RoomService.name);

  create(createRoomDTO: CreateRoomDTO) {
    return this.prisma.room.create({ data: createRoomDTO });
  }

  async createNewRoom(userId: string) {
    this.logger.log(`createNewRoom for userId: ${userId}`);
    const roomId = uuid();

    const createRoomDTO: CreateRoomDTO = {
      roomId,
      user1: userId,
    };
    this.logger.log(`createNewRoom DTO: ${JSON.stringify(createRoomDTO)}`);
    await this.create(createRoomDTO);
    return roomId;
  }

  async addUserInRoom(room: CreateRoomDTO, userId: string) {
    this.logger.log(`addUserInRoom add user ${userId} in room ${room.roomId}`);
    const user = {
      user1: '',
      user2: '',
    };
    const { user1, user2 } = room;
    user.user1 = user1 ? user1 : userId;
    user.user2 = user1 ? userId : user2;

    this.logger.log(
      `addUserInRoom update user ${JSON.stringify(user)} in roomId ${room.roomId}`,
    );
    await this.prisma.room.update({
      where: {
        roomId: room.roomId,
      },
      data: {
        ...user,
      },
    });
  }

  async findRoomEmpty(
    client: WebSocket,
    roomIdJoined?: string,
  ): Promise<string> {
    this.logger.log(`findRoomEmpty for client id: ${client.id}`);
    const roomEmpty = await this.prisma.room.findFirst({
      where: {
        OR: [
          { user1: null, NOT: { user2: null }, isDeleted: false },
          { user2: null, NOT: { user1: null }, isDeleted: false },
        ],
        NOT: {
          roomId: roomIdJoined,
        },
      },
    });
    this.logger.log(`findRoomEmpty result in DB: ${JSON.stringify(roomEmpty)}`);
    if (roomEmpty) {
      const roomId = roomEmpty.roomId;
      this.logger.log(`Add user in roomId ${roomId}`);
      await this.addUserInRoom(roomEmpty, client.id);
      this.logger.log(`Add user in roomId ${roomId} success`);
      return roomId;
    }

    this.logger.log(`Create new room`);
    const roomId = await this.createNewRoom(client.id);
    this.logger.log(`Create new room success`);
    return roomId;
  }

  async findUserInRoom(userId: string) {
    this.logger.log(`findUserInRoom userId ${userId}`);
    const userInRoom = await this.prisma.room.findFirst({
      where: {
        OR: [
          { user1: userId, isDeleted: false },
          { user2: userId, isDeleted: false },
        ],
      },
    });
    this.logger.log(`findUserInRoom result ${JSON.stringify(userInRoom)}`);
    return userInRoom;
  }

  async removeUserInRoom(roomId: string, user1: string, user2: string) {
    this.logger.log(
      `removeUserInRoom userId1 ${user1}, userId2 ${user2} in roomId ${roomId}`,
    );
    await this.prisma.room.update({
      where: {
        roomId,
      },
      data: {
        user1,
        user2,
      },
    });
    this.logger.log(`removeUserInRoom success`);
  }

  async addClientToRoom(roomId: string, clientId: string): Promise<void> {
    this.logger.log(`addClientToRoom clientId ${clientId} in roomId ${roomId}`);
    const existingClients = await this.getClientsInRoom(roomId);
    existingClients.push(clientId);
    await this.redisService.set(
      `room:${roomId}`,
      JSON.stringify(existingClients),
    );
    this.logger.log(
      `addClientToRoom clientId ${clientId} in roomId ${roomId} success`,
    );
  }

  async getClientsInRoom(roomId: string): Promise<string[]> {
    this.logger.log(`get clientIds in roomId ${roomId}`);
    const clientString = await this.redisService.get(`room:${roomId}`);
    this.logger.log(`get clientIds in roomId ${roomId} result ${clientString}`);
    return clientString ? JSON.parse(clientString) : [];
  }

  async removeClientFromRoom(roomId: string, clientId: string): Promise<void> {
    this.logger.log(
      `removeClientFromRoom clientId ${clientId} in roomId ${roomId}`,
    );
    const existingClients = await this.getClientsInRoom(roomId);
    const index = existingClients.findIndex((id: string) => id === clientId);
    if (index !== -1) {
      existingClients.splice(index, 1);
      await this.redisService.set(
        `room:${roomId}`,
        JSON.stringify(existingClients),
      );
    }
    this.logger.log(
      `removeClientFromRoom clientId ${clientId} in roomId ${roomId} result ${JSON.stringify(existingClients)}`,
    );
  }
}
