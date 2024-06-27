import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { WsAdapter } from '@nestjs/platform-ws';
import { ValidationPipe } from '@nestjs/common';
import { JwtAuthGuard } from 'auth/guard/jwt-auth.guard';
import { RolesGuard } from 'auth/guard/role.guard';
import { Reflector } from '@nestjs/core';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useWebSocketAdapter(new WsAdapter(app));
  app.useGlobalPipes(new ValidationPipe());
  const reflector = app.get(Reflector);
  app.useGlobalGuards(new JwtAuthGuard(reflector));
  // Use the RolesGuard globally
  app.useGlobalGuards(new RolesGuard(reflector));
  await app.listen(8080);
}
bootstrap();
