import { Injectable, Logger } from '@nestjs/common';
import { Server, WebSocket } from 'ws';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class RoomRedisService {
  constructor(private readonly redisService: RedisService) {}
  private readonly logger = new Logger(RoomRedisService.name);

  async findClientAnotherInRoomRedis(
    server: Server,
    client: WebSocket,
    roomId: string,
  ): Promise<WebSocket> {
    const clientIds = await this.getClientsInRoomRedis(roomId);
    const clientIdAnother = clientIds.find((id) => id !== client.id);
    this.logger.log(`clientIdAnother ${JSON.stringify(clientIdAnother)}`);
    for (const wsClient of server.clients) {
      if (wsClient.id === clientIdAnother) {
        return wsClient;
      }
    }
    return null;
  }

  async removeRoom(roomId: string): Promise<boolean> {
    try {
      this.logger.log(`removeRoom roomId ${roomId}`);
      await this.redisService.del(`room:${roomId}`);
      return true;
    } catch (error) {
      this.logger.error(`removeRoom error: ${error}`);
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
}
