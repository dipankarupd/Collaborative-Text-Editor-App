import 'package:app/common/entity/user_entity.dart';
import 'package:app/features/auth/domain/entity/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toMap(),
    };
  }

  factory AuthModel.fromJson(Map<String, dynamic> map) {
    return AuthModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      user: User.fromJson(map['user'] as Map<String, dynamic>),
    );
  }
}
