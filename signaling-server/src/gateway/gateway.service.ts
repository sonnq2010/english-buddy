// src/events/events.gateway.ts
import { Logger } from '@nestjs/common';
import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, WebSocket } from 'ws';
import { Room } from '../room/dto/room.dto';
import { SocketMessageService } from '../socket-message/socket-message.service';

@WebSocketGateway({ path: '/ws' })
export class GatewayService
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer() server: Server;
  rooms: Room = {};

  private logger: Logger = new Logger('EventsGateway');
  constructor(private socketService: SocketMessageService) {}

  afterInit() {
    this.logger.log('WebSocket server initialized');
  }

  handleConnection(client: WebSocket) {
    this.logger.log('Client connected');
    client.on('message', (message: string) => {
      this.handleMessage(client, message);
    });
    this.socketService.handleClientConnect(client);
  }

  handleDisconnect(client: WebSocket) {
    this.socketService.handleLeaveRoom(client);
    this.logger.log('Client disconnected');
  }

  handleMessage(client: WebSocket, message: string) {
    this.socketService.handleMessage(client, message);
  }
}
