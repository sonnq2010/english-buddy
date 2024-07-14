import 'package:frontend/constants.dart';

class UpdateProfileDto {
  const UpdateProfileDto({
    this.name,
    this.avatar,
    this.gender,
    this.expectedGender,
    this.level,
    this.expectedLevel,
  });

  final String? name;
  final String? avatar;
  final String? gender;
  final String? expectedGender;
  final String? level;
  final String? expectedLevel;

  Map<String, dynamic> toJson() {
    // if (name != null) json['name'] = name;
    // if (avatar != null) json['avatar'] = avatar;
    // if (gender != null) json['gender'] = gender;
    // if (expectedGender != null) json['filterGender'] = expectedGender;
    // if (level != null) json['englishLevel'] = level;
    // if (expectedLevel != null) json['filterEnglishLevel'] = expectedLevel;

    final json = <String, dynamic>{};
    json['name'] = name;
    json['avatar'] = avatar;
    if (gender == Gender.all.name) {
      json['gender'] = null;
    } else {
      json['gender'] = gender;
    }
    if (expectedGender == Gender.all.name) {
      json['filterGender'] = null;
    } else {
      json['filterGender'] = expectedGender;
    }
    if (level == EnglishLevel.all.name) {
      json['englishLevel'] = null;
    } else {
      json['englishLevel'] = level;
    }
    if (expectedLevel == EnglishLevel.all.name) {
      json['filterEnglishLevel'] = null;
    } else {
      json['filterEnglishLevel'] = expectedLevel;
    }
    return json;
  }
}
