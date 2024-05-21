// src/events/events.gateway.ts
import { WebSocketGateway, OnGatewayInit, WebSocketServer, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Logger } from '@nestjs/common';
import { Server, WebSocket } from 'ws';

@WebSocketGateway({ path: '/ws' })
export class GatewayService implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;
  private logger: Logger = new Logger('EventsGateway');

  afterInit(server: Server) {
    this.logger.log('WebSocket server initialized');
  }

  handleConnection(client: WebSocket) {
    this.logger.log('Client connected');
    client.on('message', (message: string) => {
        this.logger.log('WTH');
      this.handleMessage(client, message);
    });
    client.send(JSON.stringify({type: 'text', data: 'Welcome to the WebSocket server!'}));
  }

  handleDisconnect(client: WebSocket) {
    this.logger.log('Client disconnected');
  }

  handleMessage(client: WebSocket, message: string) {
    this.logger.log(`Received message: ${message}`);
    client.send(`Hello! You sent -> ${message}`);
  }
}
