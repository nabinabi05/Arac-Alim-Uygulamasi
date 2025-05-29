// File: lib/models/user.dart
class AuthUser {
  final int id;
  final String email;

  AuthUser({required this.id, required this.email});

  factory AuthUser.fromMap(Map<String, dynamic> map) => AuthUser(
        id: map['id'] as int,
        email: map['email'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
      };
}
