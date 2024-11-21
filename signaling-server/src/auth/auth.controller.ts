import { Body, Controller, Post, Res } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto, LoginUserDto } from './DTO/auth.dto';
import { Response } from 'express';
import { responseData } from 'common/helper/response';
import { Public } from './guard/public.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  //controller register
  @Public()
  @Post('register')
  async register(@Body() createUserDto: CreateUserDto, @Res() res: Response) {
    return responseData(res, await this.authService.register(createUserDto));
  }

  //controller login
  @Public()
  @Post('login')
  async login(@Body() loginUserDto: LoginUserDto, @Res() res: Response) {
    return responseData(res, await this.authService.signIn(loginUserDto));
  }
}
