import { WebSocket } from 'ws';

export class RoomDTO {
  roomId: string;
  user1?: string;
  user2?: string;
  ipUser1?: string;
  ipUser2?: string;
  isDeleted?: boolean;

  constructor(partial: Partial<RoomDTO>) {
    Object.assign(this, partial);
  }
}

export interface Room {
  [key: string]: Set<WebSocket>;
}
