import { Module } from '@nestjs/common';
import { PrismaModule } from 'prisma/prisma.module';
import { ReportUserController } from './report-user.controller';
import { ReportUserService } from './report-user.service';
import { RoomModule } from 'room/room.module';
import { AuthModule } from 'auth/auth.module';

@Module({
  imports: [PrismaModule, RoomModule, AuthModule],
  controllers: [ReportUserController],
  providers: [ReportUserService],
})
export class ReportUserModule {}
