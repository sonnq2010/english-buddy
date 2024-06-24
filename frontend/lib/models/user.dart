class User {
  User({
    required this.id,
    required this.userName,
    required this.idToken,
  });

  String id;
  String userName;
  String idToken;

  void updateWith({
    String? userName,
  }) {
    this.userName = userName ?? this.userName;
  }
}
