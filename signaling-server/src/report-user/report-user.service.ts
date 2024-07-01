import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';
import { CreateReportUserDto } from './dto/report-user.dto';
import { ResponseData } from 'common/params/response.data';
import { RoomService } from 'room/room.service';
import { AuthService } from 'auth/auth.service';

@Injectable()
export class ReportUserService {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly roomService: RoomService,
    private readonly authService: AuthService,
  ) {}
  private readonly logger = new Logger(ReportUserService.name);

  async reportUser(createReportUserDto: CreateReportUserDto) {
    const resData = new ResponseData();
    this.logger.log(`Reporting user ${JSON.stringify(createReportUserDto)}`);
    try {
      const room = await this.roomService.findUserInRoom(
        createReportUserDto.reporter,
      );
      if (!room || room.roomId !== createReportUserDto.roomId) {
        this.logger.warn(
          `User ${createReportUserDto.reporter} not in any room or not in the same room as the reported user`,
        );
        resData.hasError = true;
        resData.message =
          'User not in any room or not in the same room as the reported user';
        return resData;
      }

      if (!room.user1 || !room.user2) {
        this.logger.warn(`Not have user in room for reporting user`);
        resData.hasError = true;
        resData.message = 'Not have user in room for reporting user';
        return resData;
      }

      const reportedUser =
        room.user1 === createReportUserDto.reporter ? room.user2 : room.user1;
      const reportedIP =
        room.user1 === createReportUserDto.reporter
          ? room.ipUser2
          : room.ipUser1;
      this.logger.log(`Reported user: ${reportedUser}, IP: ${reportedIP}`);
      const isUserRegistered = await this.authService.findOne(reportedUser);
      this.logger.log(`Is user registered: ${isUserRegistered}`);
      const reportedIPSave = isUserRegistered ? null : reportedIP;

      const reportedUserSaved = await this.prismaService.reportUser.create({
        data: {
          reason: createReportUserDto.reason,
          reporter: createReportUserDto.reporter,
          reportedUser,
          reportedIP: reportedIPSave,
        },
      });
      resData.appData = reportedUserSaved;
      resData.message = 'User reported successfully';
      return resData;
    } catch (error) {
      this.logger.error(`Error while reporting user: ${error}`);
      resData.hasError = true;
      resData.message = 'Error while reporting user. Please try again later!';
      return resData;
    }
  }
}
