import { Module } from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { SocketMessageModule } from '../socket-message/socket-message.module';

@Module({
  imports: [SocketMessageModule],
  providers: [GatewayService],
})
export class GatewayModule {}
