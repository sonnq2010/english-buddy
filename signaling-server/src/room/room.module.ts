import { Module } from '@nestjs/common';
import { RoomService } from './room.service';
import { PrismaModule } from '../prisma/prisma.module';
import { RoomRedisModule } from '../room-redis/room-redis.module';
import { RoomSocketModule } from '../room-socket/room-socket.module';

@Module({
  providers: [RoomService],
  imports: [PrismaModule, RoomRedisModule, RoomSocketModule],
  exports: [RoomService],
})
export class RoomModule {}
