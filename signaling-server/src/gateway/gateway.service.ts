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
import { TypeSocketMessage } from '../socket-message/dto/socket.dto';
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
      this.handleMessage(client, message, this.server);
    });
    this.socketService.generateClientId(client);
  }

  handleDisconnect(client: WebSocket) {
    this.socketService.leaveRoom(client, this.server);
    this.logger.log('Client disconnected');
  }

  handleMessage(client: WebSocket, message: string, server: Server) {
    this.logger.log(`handleMessage message: ${message}`);
    try {
      const messageJSON = JSON.parse(message);
      switch (messageJSON.type) {
        case TypeSocketMessage.join:
          this.socketService.joinRoom(client, server);
          break;
        case TypeSocketMessage.stop:
          this.socketService.leaveRoom(client, server);
          break;
        case TypeSocketMessage.skip:
          this.socketService.skipRoom(client, server, messageJSON.data.roomId);
          break;
        case TypeSocketMessage.offer:
          this.socketService.sendMessageForAnotherInRoom(
            server,
            client,
            messageJSON.data.roomId,
            JSON.stringify(messageJSON),
          );
          break;
        case TypeSocketMessage.candidates:
          this.socketService.sendMessageForAnotherInRoom(
            server,
            client,
            messageJSON.data.roomId,
            JSON.stringify(messageJSON),
          );
          break;
        case TypeSocketMessage.answer:
          this.socketService.sendMessageForAnotherInRoom(
            server,
            client,
            messageJSON.data.roomId,
            JSON.stringify(messageJSON),
          );
          break;
        case TypeSocketMessage.chat:
          break;
        default:
          break;
      }
    } catch {
      this.logger.log('handleMessage can not parse message to JSON');
    }
  }
}
