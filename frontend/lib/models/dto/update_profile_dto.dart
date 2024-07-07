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
    json['gender'] = gender;
    json['filterGender'] = expectedGender;
    json['englishLevel'] = level;
    json['filterEnglishLevel'] = expectedLevel;
    return json;
  }
}
