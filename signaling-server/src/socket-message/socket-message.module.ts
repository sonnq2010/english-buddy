import { Module } from '@nestjs/common';
import { SocketMessageService } from './socket-message.service';
import { RoomModule } from '../room/room.module';

@Module({
  imports: [RoomModule],
  providers: [SocketMessageService],
  exports: [SocketMessageService],
})
export class SocketMessageModule {}
