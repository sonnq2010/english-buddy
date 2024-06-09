import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Room, RoomDTO } from './dto/room.dto';
import { v4 as uuidv4 } from 'uuid';
import { RoomRedisService } from 'room-redis/room-redis.service';
import { RoomSocketService } from 'room-socket/room-socket.service';
import { WebSocket } from 'ws';

@Injectable()
export class RoomService {
  constructor(
    private prisma: PrismaService,
    private readonly roomRedisService: RoomRedisService,
    private readonly roomSocketService: RoomSocketService,
  ) {}

  private logger = new Logger(RoomService.name);
  roomServers: Room[] = [];

  async findAllRoomEmpty(roomIdJoined?: string): Promise<RoomDTO[]> {
    try {
      this.logger.log(`findAllRoomEmpty`);
      const rooms: RoomDTO[] = await this.prisma.room.findMany({
        where: {
          NOT: { user1: null, roomId: roomIdJoined ?? '' },
          user2: null,
          isDeleted: false,
        },
        orderBy: {
          createdAt: 'asc',
        },
      });
      return rooms;
    } catch (error) {
      this.logger.error(`findAllRoomEmpty error: ${error}`);
      return [];
    }
  }

  async create(roomDTO: RoomDTO): Promise<RoomDTO> {
    try {
      this.logger.log(`create : ${JSON.stringify(roomDTO)}`);
      const room: RoomDTO = await this.prisma.room.create({ data: roomDTO });
      return room;
    } catch (error) {
      this.logger.error(`create error: ${error}`);
      return null;
    }
  }

  async createNewRoom(client: WebSocket): Promise<RoomDTO> {
    try {
      if (!client) return null;
      this.logger.log(`createNewRoom for user id: ${client.id}`);
      const roomDTO = new RoomDTO({
        roomId: uuidv4(),
        user1: client.id,
      });
      const room: RoomDTO = await this.create(roomDTO);
      await this.roomRedisService.addClientToRoomRedis(room.roomId, client.id);
      this.roomSocketService.addClientToSocketMessageRooms(room.roomId, client);
      return room;
    } catch (error) {
      this.logger.error(`createNewRoom error: ${error}`);
      return null;
    }
  }

  async update(roomDTO: RoomDTO): Promise<RoomDTO> {
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

  async addUserInRoom(roomId: string, client: WebSocket): Promise<RoomDTO> {
    try {
      this.logger.log(`addUserInRoom add user ${client.id} in room ${roomId}`);
      if (!client || !roomId) return null;
      const roomDTO = await this.update({
        roomId,
        user2: client.id,
      });
      await this.roomRedisService.addClientToRoomRedis(roomId, client.id);
      this.roomSocketService.addClientToSocketMessageRooms(roomId, client);
      return roomDTO;
    } catch (error) {
      this.logger.error(`addUserInRoom error: ${error}`);
      return null;
    }
  }

  async findRoomEmpty(userId: string, roomIdJoined?: string): Promise<RoomDTO> {
    try {
      this.logger.log(`findRoomEmpty for user id: ${userId}`);
      const roomListEmpty = await this.findAllRoomEmpty(roomIdJoined);
      if (!roomListEmpty || roomListEmpty.length === 0) return null;

      for (const roomEmpty of roomListEmpty) {
        const isActive = await this.checkUserActiveInRoom(
          roomEmpty.roomId,
          roomEmpty.user1,
        );
        this.logger.log(`findRoomEmpty isActive ${isActive}`);
        if (isActive) return roomEmpty;
        await this.removeRoom(roomEmpty.roomId);
        continue;
      }
      return null;
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

  async removeRoom(roomId: string): Promise<boolean> {
    try {
      this.logger.log(`remove room roomId ${roomId}`);
      await this.update({
        roomId,
        isDeleted: true,
      });
      await this.roomRedisService.removeRoom(roomId);
      this.roomSocketService.removeSocketMessageRoom(roomId);
      return true;
    } catch (error) {
      this.logger.error(`remove room error: ${error}`);
      return false;
    }
  }

  async checkUserActiveInRoom(
    roomId: string,
    userId: string,
  ): Promise<boolean> {
    this.logger.log(
      `checkUserActiveInRoom clientId ${userId} in roomId ${roomId}`,
    );
    const checkUserActiveInSocketMessageRooms =
      this.roomSocketService.checkClientIdInSocketMessageRooms(roomId, userId);
    if (checkUserActiveInSocketMessageRooms) {
      return true;
    }
    return false;
  }
}
