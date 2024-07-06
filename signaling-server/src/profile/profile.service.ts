import { Injectable, Logger } from '@nestjs/common';
import { Profile } from '@prisma/client';
import { error } from 'console';
import { PrismaService } from 'prisma/prisma.service';
import { UpdateProfileDTO } from './dto/profile.dto';
import { ResponseData } from 'common/params/response.data';

@Injectable()
export class ProfileService {
  constructor(private readonly prismaService: PrismaService) {}
  private readonly logger = new Logger(ProfileService.name);

  async createProfile(userId: string, username: string): Promise<boolean> {
    try {
      this.logger.log(`createProfile userId: ${userId}, username: ${username}`);
      await this.prismaService.profile.create({
        data: {
          userId,
          name: username,
        },
      });
      return true;
    } catch (error) {
      this.logger.error(
        `createProfile userId: ${userId}, username: ${username} have error: ${error}`,
      );
      return false;
    }
  }

  async getProfile(userId: string): Promise<Profile> {
    try {
      this.logger.log(`getProfile userId: ${userId}`);
      const profile = await this.prismaService.profile.findUnique({
        where: {
          userId,
        },
      });
      return profile;
    } catch {
      this.logger.log(`getProfile userId: ${userId}, have error: ${error}`);
      return null;
    }
  }

  async updateProfile(userId: string, updateProfileDTO: UpdateProfileDTO) {
    const resData = new ResponseData();
    try {
      this.logger.log(`updateProfile, ${JSON.stringify(updateProfileDTO)}`);
      const {
        avatar,
        name,
        gender,
        filterGender,
        englishLevel,
        filterEnglishLevel,
      } = updateProfileDTO;
      const profile = await this.prismaService.profile.update({
        where: {
          userId,
        },
        data: {
          avatar: avatar,
          name: name,
          gender: gender ? gender.toString() : null,
          filterGender: filterGender ? filterGender.toString() : null,
          englishLevel: englishLevel ? englishLevel.toString() : null,
          filterEnglishLevel: filterEnglishLevel
            ? filterEnglishLevel.toString()
            : null,
        },
      });
      resData.appData = profile;
      resData.message = 'Update profile success';
      return resData;
    } catch (error) {
      this.logger.error(
        `updateProfile, ${JSON.stringify(updateProfileDTO)} have error: ${error}`,
      );
      resData.hasError = true;
      resData.message = 'Update profile have error, please try again!';
      return resData;
    }
  }
}
