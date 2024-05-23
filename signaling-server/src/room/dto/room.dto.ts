import { WebSocket } from 'ws';

export class CreateRoomDTO {
    roomId: string;
    user1?: string;
    user2?: string;
}

export interface Room {
    [key: string]: Set<WebSocket>;
}