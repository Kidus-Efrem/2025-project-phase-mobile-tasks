import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'id' and '_id' fields like the authentication model
    final String parsedId = (json['id'] ?? json['_id'] ?? '').toString();
    final String parsedEmail = (json['email'] ?? '').toString();
    final String parsedName = (json['name'] ?? json['fullName'] ?? '').toString();
    
    return UserModel(
      id: parsedId,
      email: parsedEmail,
      name: parsedName,
      token: json['token'],
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
