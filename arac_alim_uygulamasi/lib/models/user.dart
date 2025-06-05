// lib/models/user.dart

class UserModel {
  final int id;
  final String username;

  UserModel({required this.id, required this.username});

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id'] as int,
        username: j['username'] as String,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
      };
}
