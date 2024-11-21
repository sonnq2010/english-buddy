import { Module } from '@nestjs/common';
import { RedisModule } from '../redis/redis.module';
import { RoomRedisService } from './room-redis.service';

@Module({
  imports: [RedisModule],
  providers: [RoomRedisService],
  exports: [RoomRedisService],
})
export class RoomRedisModule {}
