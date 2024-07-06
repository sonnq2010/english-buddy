import { IsEnum, IsNotEmpty, IsOptional } from 'class-validator';
import { LevelEnglish } from 'profile/enum/english.eum';
import { Gender } from 'profile/enum/gender.enum';

export class UpdateProfileDTO {
  avatar: string;

  @IsNotEmpty()
  name: string;

  @IsOptional()
  @IsEnum(Gender)
  gender: Gender;

  @IsOptional()
  @IsEnum(Gender)
  filterGender: Gender;

  @IsOptional()
  @IsEnum(LevelEnglish)
  englishLevel: LevelEnglish;

  @IsOptional()
  @IsEnum(LevelEnglish)
  filterEnglishLevel: LevelEnglish;
}
