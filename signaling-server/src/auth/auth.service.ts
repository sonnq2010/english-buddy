import { Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { ResponseData } from 'common/params/response.data';
import { v4 as uuidv4 } from 'uuid';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto, LoginUserDto } from './DTO/auth.dto';
import { Role } from './guard/role.enum';
import { User } from '@prisma/client';
import { ProfileService } from 'profile/profile.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly profileService: ProfileService,
    private readonly jwtService: JwtService,
  ) {}
  private readonly logger = new Logger(AuthService.name);

  async register(createUserDto: CreateUserDto): Promise<ResponseData> {
    this.logger.log(`Registering user ${createUserDto.username}`);
    const resData = new ResponseData();
    try {
      if (await this.checkUserNameExist(createUserDto.username)) {
        this.logger.warn(`Username ${createUserDto.username} already exist`);
        resData.hasError = true;
        resData.message = 'Username already exist';
        return resData;
      }
      if (!createUserDto.userId) createUserDto.userId = uuidv4();
      if (createUserDto.password !== createUserDto.confirmPassword) {
        this.logger.warn('Password and Confirm Password do not match');
        resData.hasError = true;
        resData.message = 'Password and Confirm Password do not match';
        return resData;
      }
      delete createUserDto.confirmPassword;
      const saltOrRounds = 10;
      const hash = await bcrypt.hash(createUserDto.password, saltOrRounds);
      const user = await this.prismaService.user.create({
        data: {
          ...createUserDto,
          password: hash,
        },
      });
      await this.profileService.createProfile(
        createUserDto.userId,
        createUserDto.username,
      );
      delete user.password;
      resData.appData = user;
      resData.message = 'User registered successfully';
      return resData;
    } catch (error) {
      this.logger.error(
        `Error registering user ${createUserDto.username} error: ${error}`,
      );
      resData.hasError = true;
      resData.message =
        'Have error when register user. Please try again later!';
      throw error;
    }
  }

  async checkUserNameExist(username: string): Promise<boolean> {
    this.logger.log(`Checking username ${username} exist`);
    try {
      const user = await this.prismaService.user.findFirst({
        where: {
          username,
        },
      });
      this.logger.log(`Username ${username} exist: ${!!user}`);
      return !!user;
    } catch (error) {
      this.logger.error(
        `Error checking username ${username} exist error: ${error}`,
      );
      return true;
    }
  }

  async signIn(loginUserDto: LoginUserDto): Promise<ResponseData> {
    const resData = new ResponseData();
    this.logger.log(`Sign in user ${loginUserDto.username}`);
    try {
      const user = await this.prismaService.user.findUnique({
        where: {
          username: loginUserDto.username,
        },
      });
      if (!user) {
        this.logger.warn(`User ${loginUserDto.username} is not existed`);
        resData.hasError = true;
        resData.message = 'User is not existed!';
        return resData;
      }

      const pwdMatches = await bcrypt.compare(
        loginUserDto.password,
        user.password,
      );
      if (!pwdMatches) {
        this.logger.warn('Password does not match');
        resData.hasError = true;
        resData.message =
          'Username or password is incorrect. Please try again!';
        return resData;
      }
      const payload = {
        id: user.userId,
        username: user.username,
        role: user.isAdmin ? Role.Admin : Role.User,
      };
      delete user.password;
      const profile = await this.profileService.getProfile(user.userId);
      resData.appData = {
        ...user,
        profile,
        access_token: await this.jwtService.signAsync(payload),
      };
      resData.message = 'User signed in successfully';
      return resData;
    } catch (error) {
      this.logger.error(
        `Error signing in user ${loginUserDto.username} error: ${error}`,
      );
      resData.hasError = true;
      resData.message = 'Have error when sign in. Please try again later!';
      throw error;
    }
  }

  async findOne(userId: string): Promise<User> {
    this.logger.log(`Find user ${userId}`);
    try {
      const user = await this.prismaService.user.findUnique({
        where: {
          userId,
        },
      });
      if (user) delete user.password;
      return user;
    } catch (error) {
      this.logger.error(`Error finding user ${userId} error: ${error}`);
      return null;
    }
  }
}
