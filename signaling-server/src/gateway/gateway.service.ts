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
      this.handleMessage(client, message);
    });
    this.socketService.generateClientId(client);
  }

  handleDisconnect(client: WebSocket) {
    this.socketService.leaveRoom(client, this.rooms);
    this.logger.log('Client disconnected');
  }

  handleMessage(client: WebSocket, message: string) {
    this.logger.log(`Received message: ${message}`);
    try {
      const messageJSON = JSON.parse(message);
      switch (messageJSON.type) {
        case TypeSocketMessage.join:
          this.socketService.joinRoom(client, this.rooms);
          break;
        case TypeSocketMessage.stop:
          this.socketService.leaveRoom(client, this.rooms);
          break;
        case TypeSocketMessage.skip:
          this.socketService.skipRoom(client, this.rooms);
          break;
        case TypeSocketMessage.offer:
          this.logger.log(`send offer: ${messageJSON.roomId}, message: ${message}`)
          this.socketService.sendMessageForAnotherInRoom(client, this.rooms, messageJSON.roomId, JSON.stringify(messageJSON));
          break;
        case TypeSocketMessage.candidates:
          this.socketService.sendMessageForAnotherInRoom(client, this.rooms, messageJSON.roomId, JSON.stringify(messageJSON));
          break;
        case TypeSocketMessage.answer:
          this.socketService.sendMessageForAnotherInRoom(client, this.rooms, messageJSON.roomId, JSON.stringify(messageJSON));
          break;
        case TypeSocketMessage.chat:
          this.socketService.sendMessageForAnotherInRoom(client, this.rooms, messageJSON.roomId, message);
          break;
        default:
          break;
      }
    } catch {
      this.logger.log('handleMessage can not parse message to JSON');
    }
  }

  handleJoin() {

  }
}
