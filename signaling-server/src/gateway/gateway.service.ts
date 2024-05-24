// src/events/events.gateway.ts
import { WebSocketGateway, OnGatewayInit, WebSocketServer, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Logger } from '@nestjs/common';
import { Server, WebSocket } from 'ws';
import { SocketMessageService } from '../socket-message/socket-message.service';
import { Room } from '../room/dto/room.dto';
import { TypeSocketMessage } from '../socket-message/dto/socket.dto'; 

@WebSocketGateway({ path: '/ws' })
export class GatewayService implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;
  rooms: Room = {};

  private logger: Logger = new Logger('EventsGateway');
  constructor(private socketService: SocketMessageService) {}

  afterInit(server: Server) {
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
          this.logger.log(`send join message: ${message}`)
          this.socketService.joinRoom(client, server);
          break;
        case TypeSocketMessage.stop:
          this.logger.log(`send stop message: ${message}`)
          this.socketService.leaveRoom(client, server);
          break;
        case TypeSocketMessage.skip:
          this.logger.log(`send skip message: ${message}`)
          this.socketService.skipRoom(client, server);
          break;
        case TypeSocketMessage.offer:
          this.logger.log(`send offer message: ${message}`)
          this.socketService.sendMessageForAnotherInRoom(server, client, messageJSON.roomId, JSON.stringify(messageJSON));
          break;
        case TypeSocketMessage.candidates:
          this.logger.log(`send candidates message: ${message}`)
          this.socketService.sendMessageForAnotherInRoom(server, client, messageJSON.roomId, JSON.stringify(messageJSON));
          break;
        case TypeSocketMessage.answer:
          this.logger.log(`send answer message: ${message}`)
          this.socketService.sendMessageForAnotherInRoom(server, client, messageJSON.roomId, JSON.stringify(messageJSON));
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
