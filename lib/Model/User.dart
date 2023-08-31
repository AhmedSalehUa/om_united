import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String name;
  final String user_name;
  final String email;
  final String role;
  final String token;
  final String userImage;

  User(
      {required this.id,
      required this.name,
      required this.user_name,
      required this.email,
      required this.role,
      required this.token,
      required this.userImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: int.parse(json['id']),
        name: json['name'],
        email: json['email'],
        role: json['role'],
        userImage: json['img'],
        token: json['token'],
        user_name: json['user_name']);
  }
}
