import { IsNotEmpty } from 'class-validator';

export class CreateReportUserDto {
  @IsNotEmpty()
  reporter: string;

  @IsNotEmpty()
  roomId: string;

  @IsNotEmpty()
  reason: string;
}
