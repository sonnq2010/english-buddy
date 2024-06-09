import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Room, RoomDTO } from './dto/room.dto';
// import { WebSocket } from 'ws';
import { RedisService } from '../redis/redis.service';
// import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class RoomService {
  constructor(
    private prisma: PrismaService,
    private readonly redisService: RedisService,
  ) {}

  private logger = new Logger(RoomService.name);
  roomServers: Room[] = [];

  async createNewRoom(roomDTO: RoomDTO): Promise<RoomDTO> {
    try {
      this.logger.log(`createNewRoom : ${JSON.stringify(roomDTO)}`);
      // const roomId = uuidv4();
      // this.logger.log(`createNewRoom DTO: ${JSON.stringify(roomDTO)}`);
      const room: RoomDTO = await this.prisma.room.create({ data: roomDTO });
      return room;
    } catch (error) {
      this.logger.error(`createNewRoom error: ${error}`);
      return null;
    }
  }

  async updateRoom(roomDTO: RoomDTO): Promise<RoomDTO> {
    try {
      this.logger.log(`updateRoom : ${JSON.stringify(roomDTO)}`);
      const room: RoomDTO = await this.prisma.room.update({
        where: {
          roomId: roomDTO.roomId,
        },
        data: {
          ...roomDTO,
        },
      });
      return room;
    } catch (error) {
      this.logger.error(`updateRoom error: ${error}`);
      return null;
    }
  }

  async addUserInRoom(roomDTO: RoomDTO, userId: string) {
    this.logger.log(
      `addUserInRoom add user ${userId} in room ${roomDTO.roomId}`,
    );
    const { user1, user2 } = roomDTO;
    roomDTO.user1 = user1 ? user1 : userId;
    roomDTO.user2 = user1 ? userId : user2;

    this.logger.log(
      `addUserInRoom update user ${JSON.stringify(userId)} in roomId ${roomDTO.roomId}`,
    );
    await this.prisma.room.update({
      where: {
        roomId: roomDTO.roomId,
      },
      data: {
        ...roomDTO,
      },
    });
  }

  async findRoomEmpty(userId: string, roomIdJoined?: string): Promise<RoomDTO> {
    try {
      this.logger.log(`findRoomEmpty for user id: ${userId}`);
      const roomEmpty: RoomDTO = await this.prisma.room.findFirst({
        where: {
          OR: [
            { user1: null, NOT: { user2: null }, isDeleted: false },
            { user2: null, NOT: { user1: null }, isDeleted: false },
          ],
          NOT: {
            roomId: roomIdJoined ?? '',
          },
        },
      });
      this.logger.log(
        `findRoomEmpty result in DB: ${JSON.stringify(roomEmpty)}`,
      );
      // if (roomEmpty) {
      //   const roomId = roomEmpty.roomId;
      //   this.logger.log(`Add user in roomId ${roomId}`);
      //   await this.addUserInRoom(roomEmpty, client.id);
      //   this.logger.log(`Add user in roomId ${roomId} success`);
      //   return roomId;
      // }

      // this.logger.log(`Create new room`);
      // const roomId = await this.createNewRoom(client.id);
      // this.logger.log(`Create new room success`);
      return roomEmpty;
    } catch (error) {
      this.logger.error(`findRoomEmpty error: ${error}`);
      return null;
    }
  }

  async findUserInRoom(userId: string) {
    try {
      this.logger.log(`findUserInRoom userId ${userId}`);
      const userInRoom = await this.prisma.room.findFirst({
        where: {
          OR: [
            { user1: userId, isDeleted: false },
            { user2: userId, isDeleted: false },
          ],
          NOT: {
            isDeleted: true,
          },
        },
      });
      this.logger.log(`findUserInRoom result ${JSON.stringify(userInRoom)}`);
      return userInRoom;
    } catch (error) {
      this.logger.error(`findUserInRoom error: ${error}`);
      return null;
    }
  }

  async removeUserInRoom(roomDTO: RoomDTO, userId: string) {
    this.logger.log(
      `removeUserInRoom userId ${userId} in roomId ${roomDTO.roomId}`,
    );
    const { user1, user2 } = roomDTO;
    roomDTO.user1 = user1 === userId ? null : user1;
    roomDTO.user2 = user2 === userId ? null : user2;
    if (!roomDTO.user1 && !roomDTO.user2) {
      roomDTO.isDeleted = true;
    }
    await this.prisma.room.update({
      where: {
        roomId: roomDTO.roomId,
      },
      data: {
        ...roomDTO,
      },
    });
    this.logger.log(`removeUserInRoom success`);
  }

  async addClientToRoomRedis(
    roomId: string,
    clientId: string,
  ): Promise<boolean> {
    try {
      this.logger.log(
        `addClientToRoom clientId ${clientId} in roomId ${roomId}`,
      );
      const existingClients = await this.getClientsInRoomRedis(roomId);
      existingClients.push(clientId);
      await this.redisService.set(
        `room:${roomId}`,
        JSON.stringify(existingClients),
      );
      this.logger.log(
        `addClientToRoom clientId ${clientId} in roomId ${roomId} success`,
      );
      return true;
    } catch (error) {
      this.logger.error(`addClientToRoom error: ${error}`);
      return false;
    }
  }

  async getClientsInRoomRedis(roomId: string): Promise<string[]> {
    try {
      this.logger.log(`get clientIds in roomId ${roomId}`);
      const clientString = await this.redisService.get(`room:${roomId}`);
      this.logger.log(
        `get clientIds in roomId ${roomId} result ${clientString}`,
      );
      return clientString ? JSON.parse(clientString) : [];
    } catch (error) {
      this.logger.error(`getClientsInRoom error: ${error}`);
      return [];
    }
  }

  async removeClientFromRoomRedis(
    roomId: string,
    clientId: string,
  ): Promise<boolean> {
    try {
      this.logger.log(
        `removeClientFromRoom clientId ${clientId} in roomId ${roomId}`,
      );
      const existingClients = await this.getClientsInRoomRedis(roomId);
      const index = existingClients.findIndex((id: string) => id === clientId);
      if (index === -1) {
        return true;
      }
      existingClients.splice(index, 1);
      if (existingClients.length === 0) {
        await this.redisService.del(`room:${roomId}`);
        return true;
      }
      await this.redisService.set(
        `room:${roomId}`,
        JSON.stringify(existingClients),
      );
      return true;
    } catch (error) {
      this.logger.error(`removeClientFromRoom error: ${error}`);
      return false;
    }
  }
}
