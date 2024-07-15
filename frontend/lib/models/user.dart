class Profile {
  const Profile({
    required this.name,
    this.avatar,
    this.gender,
    this.expectedGender,
    this.level,
    this.expectedLevel,
  });

  final String name;
  final String? avatar;
  final String? gender;
  final String? expectedGender;
  final String? level;
  final String? expectedLevel;

  factory Profile.fromJson(
    Map<String, dynamic>? json, {
    String? userName,
  }) {
    if (json == null) {
      return Profile(name: userName ?? '');
    }

    return Profile(
      name: json['name'] ?? userName,
      avatar: json['avatar'],
      gender: json['gender'],
      expectedGender: json['filterGender'],
      level: json['englishLevel'],
      expectedLevel: json['filterEnglishLevel'],
    );
  }

  Profile copyWith({
    String? name,
    String? avatar,
    String? gender,
    String? expectedGender,
    String? level,
    String? expectedLevel,
  }) {
    return Profile(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      expectedGender: expectedGender ?? this.expectedGender,
      level: level ?? this.level,
      expectedLevel: expectedLevel ?? this.expectedLevel,
    );
  }
}

class User {
  const User({
    required this.id,
    required this.userName,
    this.isAdmin = false,
    required this.idToken,
    required this.profile,
  });

  final String id;
  final String userName;
  final bool isAdmin;
  final String idToken;
  final Profile profile;

  static User? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return null;

    return User(
      id: json['userId'] ?? '',
      userName: json['username'] ?? '',
      idToken: json['access_token'] ?? '',
      isAdmin: bool.tryParse(json['isAdmin'].toString()) ?? false,
      profile: Profile.fromJson(
        json['profile'],
        userName: json['username'] ?? '',
      ),
    );
  }

  User copyWith({
    String? name,
    String? avatar,
    String? gender,
    String? expectedGender,
    String? level,
    String? expectedLevel,
  }) {
    return User(
      id: id,
      userName: userName,
      isAdmin: isAdmin,
      idToken: idToken,
      profile: profile.copyWith(
        name: name,
        avatar: avatar,
        gender: gender,
        expectedGender: expectedGender,
        level: level,
        expectedLevel: expectedLevel,
      ),
    );
  }
}
