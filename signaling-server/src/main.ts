import { ValidationPipe } from '@nestjs/common';
import { NestFactory, Reflector } from '@nestjs/core';
import { WsAdapter } from '@nestjs/platform-ws';
import { JwtAuthGuard } from 'auth/guard/jwt-auth.guard';
import { RolesGuard } from 'auth/guard/role.guard';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  });
  app.useWebSocketAdapter(new WsAdapter(app));
  app.useGlobalPipes(new ValidationPipe());
  const reflector = app.get(Reflector);
  app.useGlobalGuards(new JwtAuthGuard(reflector));
  // Use the RolesGuard globally
  app.useGlobalGuards(new RolesGuard(reflector));
  await app.listen(8080);
}
bootstrap();
