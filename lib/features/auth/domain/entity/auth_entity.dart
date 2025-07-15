import 'package:app/common/entity/user_entity.dart';

class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
