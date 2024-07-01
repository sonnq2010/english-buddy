class User {
  const User({
    required this.id,
    required this.userName,
    required this.idToken,
    this.isAdmin = false,
  });

  final String id;
  final String userName;
  final String idToken;
  final bool isAdmin;

  static User? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return null;

    return User(
      id: json['userId'] ?? '',
      userName: json['username'] ?? '',
      idToken: json['access_token'] ?? '',
      isAdmin: bool.tryParse(json['isAdmin'].toString()) ?? false,
    );
  }

  User copyWith({
    String? userName,
  }) {
    return User(
      id: id,
      userName: userName ?? this.userName,
      idToken: idToken,
    );
  }
}
