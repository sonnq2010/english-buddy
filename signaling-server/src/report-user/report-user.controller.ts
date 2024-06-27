import { Body, Controller, Post, Res } from '@nestjs/common';
import { ReportUserService } from './report-user.service';
import { Public } from 'auth/guard/public.decorator';
import { CreateReportUserDto } from './dto/report-user.dto';
import { responseData } from 'common/helper/response';
import { Response } from 'express';

@Controller('report-user')
export class ReportUserController {
  constructor(private readonly reportUserService: ReportUserService) {}
  // Report user
  @Public()
  @Post()
  async reportUser(
    @Body() createReportUserDto: CreateReportUserDto,
    @Res() res: Response,
  ) {
    return responseData(
      res,
      await this.reportUserService.reportUser(createReportUserDto),
    );
  }
}
