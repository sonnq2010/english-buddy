import { Module } from '@nestjs/common';
import { GatewayModule } from './gateway/gateway.module';
import { HealthModule } from './health/health.module';
import { SocketMessageModule } from './socket-message/socket-message.module';
import { PrismaModule } from './prisma/prisma.module';
import { RoomModule } from './room/room.module';
import { RedisModule } from './redis/redis.module';
import { ConfigModule } from '@nestjs/config';
import { RoomRedisModule } from './room-redis/room-redis.module';
import { RoomSocketModule } from './room-socket/room-socket.module';
import { AuthModule } from './auth/auth.module';
import { ReportUserModule } from './report-user/report-user.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    HealthModule,
    GatewayModule,
    SocketMessageModule,
    PrismaModule,
    RoomModule,
    RedisModule,
    RoomRedisModule,
    RoomSocketModule,
    AuthModule,
    ReportUserModule,
  ],
})
export class AppModule {}
