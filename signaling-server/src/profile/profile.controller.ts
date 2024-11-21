import { Body, Controller, Put, Req, Res } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { UpdateProfileDTO } from './dto/profile.dto';
import { Request, Response } from 'express';
import { responseData } from 'common/helper/response';

@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Put()
  async updateProfile(
    @Body() updateProfileDTO: UpdateProfileDTO,
    @Req() req: Request,
    @Res() res: Response,
  ) {
    return responseData(
      res,
      await this.profileService.updateProfile(
        req['user']['userId'],
        updateProfileDTO,
      ),
    );
  }
}
