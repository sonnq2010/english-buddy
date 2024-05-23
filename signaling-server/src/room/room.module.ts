import { Module } from '@nestjs/common';
import { RoomService } from './room.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  providers: [RoomService],
  imports: [PrismaModule],
  exports: [RoomService]
})
export class RoomModule {}
