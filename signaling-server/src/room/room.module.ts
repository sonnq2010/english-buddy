import { Module } from '@nestjs/common';
import { RoomService } from './room.service';
import { PrismaModule } from '../prisma/prisma.module';
import { RedisModule } from '../redis/redis.module';

@Module({
  providers: [RoomService],
  imports: [PrismaModule, RedisModule],
  exports: [RoomService],
})
export class RoomModule {}
