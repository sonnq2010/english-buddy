import { Module } from '@nestjs/common';
import { GatewayModule } from './gateway/gateway.module';
import { HealthModule } from './health/health.module';

@Module({
  imports: [HealthModule, GatewayModule],
})

export class AppModule {}
