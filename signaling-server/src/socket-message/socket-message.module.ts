import { Module } from '@nestjs/common';
import { SocketMessageService } from './socket-message.service';
import { RoomModule } from '../room/room.module';
import { RoomSocketModule } from '../room-socket/room-socket.module';

@Module({
  imports: [RoomModule, RoomSocketModule],
  providers: [SocketMessageService],
  exports: [SocketMessageService],
})
export class SocketMessageModule {}
