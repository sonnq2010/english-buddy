export class SocketMessageDTO {
  type: TypeSocketMessage;
  data: DataSocketMessageDTO;

  constructor(partial: Partial<SocketMessageDTO>) {
    Object.assign(this, partial);
  }
}

export class DataSocketMessageDTO {
  clientId?: string;
  roomId?: string;
  offer?: NonNullable<unknown>;
  candidates?: NonNullable<unknown>;
  answer?: NonNullable<unknown>;
  message?: string;
}

export enum TypeSocketMessage {
  id = 'id',
  join = 'join',
  offer = 'offer',
  candidates = 'candidates',
  answer = 'answer',
  skip = 'skip',
  stop = 'stop',
  chat = 'chat',
}
