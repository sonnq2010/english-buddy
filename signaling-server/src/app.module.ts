import { Module } from '@nestjs/common';
import { GatewayModule } from './gateway/gateway.module';
import { HealthModule } from './health/health.module';
import { SocketMessageModule } from './socket-message/socket-message.module';
import { PrismaModule } from './prisma/prisma.module';
import { RoomModule } from './room/room.module';
import { RedisModule } from './redis/redis.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule.forRoot(),
    HealthModule,
    GatewayModule,
    SocketMessageModule,
    PrismaModule,
    RoomModule,
    RedisModule,
  ],
})
export class AppModule {}
