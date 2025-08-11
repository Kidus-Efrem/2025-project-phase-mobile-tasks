import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Some APIs return user fields nested under `user` and may use `_id`.
    final Map<String, dynamic> userMap =
        (json['user'] is Map<String, dynamic>) ? Map<String, dynamic>.from(json['user']) : json;

    final String parsedId = (userMap['id'] ?? userMap['_id'] ?? '').toString();
    final String parsedEmail = (userMap['email'] ?? '').toString();
    final String parsedName = (userMap['name'] ?? userMap['fullName'] ?? '').toString();

    // Token can be in multiple keys or on the root json - prioritize access_token
    final String? parsedToken = (json['access_token'] ?? json['accessToken'] ?? json['token'])?.toString();

    return UserModel(
      id: parsedId,
      email: parsedEmail,
      name: parsedName,
      token: parsedToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }
}
