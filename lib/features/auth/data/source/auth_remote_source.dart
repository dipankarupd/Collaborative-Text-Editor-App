import 'package:app/common/entity/user_entity.dart';
import 'package:app/common/exceptions/app_exception.dart';
import 'package:app/config/constants/endpoints.dart';
import 'package:app/features/auth/data/models/auth_model.dart';
import 'package:app/features/auth/data/source/auth_local_source.dart';
import 'package:app/utils/logger.dart';
import 'package:dio/dio.dart';

abstract interface class AuthRemoteSource {
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthModel> login({required String email, required String password});
  Future<AuthModel> signinWithGoogle({
    required String name,
    required String email,
  });

  Future<User> currentUser();
  Future<void> logout();
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final Dio dio;
  final AuthLocalSource authLocalSource;

  AuthRemoteSourceImpl({required this.dio, required this.authLocalSource});

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final endpoint = AppEndpoints.LOGIN;
      final data = {"email": email, "password": password};

      LoggerUtils.logRequest("Login", endpoint, data);

      final res = await dio.post(
        endpoint,
        data: data,
        options: Options(validateStatus: (status) => true),
      );

      if (res.statusCode == 200) {
        LoggerUtils.logSuccess('Login', res.statusCode, res.data);
        final AuthModel authResponse = AuthModel.fromJson(
          res.data as Map<String, dynamic>,
        );

        authLocalSource.setToken(
          authResponse.accessToken,
          authResponse.refreshToken,
        );
        return authResponse;
      } else {
        final msg =
            (res.data is Map<String, dynamic> && res.data['error'] != null)
                ? '${res.data['error'] as String}.'
                : 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      LoggerUtils.logError(
        'Login',
        e is AppException ? e.message : e.toString(),
      );
      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final endpoint = AppEndpoints.REGISTER;
      final data = {"name": name, "email": email, "password": password};

      LoggerUtils.logRequest("Register", endpoint, data);

      final res = await dio.post(
        endpoint,
        data: data,
        options: Options(validateStatus: (stat) => true),
      );

      if (res.statusCode == 201) {
        LoggerUtils.logSuccess('Register', res.statusCode, res.data);

        final AuthModel authResponse = AuthModel.fromJson(
          res.data as Map<String, dynamic>,
        );

        authLocalSource.setToken(
          authResponse.accessToken,
          authResponse.refreshToken,
        );
        return authResponse;
      } else {
        final msg =
            (res.data is Map<String, dynamic> && res.data['error'] != null)
                ? '${res.data['error'] as String}.'
                : 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      LoggerUtils.logError(
        'Register',
        e is AppException ? e.message : e.toString(),
      );
      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<User> currentUser() async {
    try {
      final endpoint = AppEndpoints.ME;

      final data = await authLocalSource.getTokens();
      LoggerUtils.logRequest("Current User", endpoint, data['access_token']);

      final res = await dio.get(endpoint);

      if (res.statusCode == 200) {
        LoggerUtils.logSuccess('Current User', res.statusCode, res.data);

        final User userResponse = User.fromJson(
          res.data as Map<String, dynamic>,
        );

        return userResponse;
      } else {
        final error = res.data?['error'] as String?;
        final msg =
            error ?? 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      // Check if it's a DioException wrapping an AppException (from interceptor)
      if (e is DioException && e.error is AppException) {
        LoggerUtils.logError('Current User', (e.error as AppException).message);
        throw e.error as AppException;
      }

      LoggerUtils.logError(
        'Current User',
        e is AppException ? e.message : e.toString(),
      );

      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      final endpoint = AppEndpoints.LOGOUT;

      final data = await authLocalSource.getTokens();
      LoggerUtils.logRequest("Logout", endpoint, data['access_token']);

      final res = await dio.post(endpoint);

      if (res.statusCode == 200) {
        LoggerUtils.logSuccess(
          'Logout',
          res.statusCode,
          res.data["success"] as String,
        );

        await authLocalSource.removeTokens();
        final t = await authLocalSource.getTokens();
        print('Tokens removed. ${t['access_token']}');
        return;
      } else {
        final error = res.data?['error'] as String?;
        final msg =
            error ?? 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      // Check if it's a DioException wrapping an AppException (from interceptor)
      if (e is DioException && e.error is AppException) {
        LoggerUtils.logError('Logout', (e.error as AppException).message);
        throw e.error as AppException;
      }

      LoggerUtils.logError(
        'Logoutr',
        e is AppException ? e.message : e.toString(),
      );

      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<AuthModel> signinWithGoogle({
    required String name,
    required String email,
  }) async {
    try {
      final endpoint = AppEndpoints.Google_LOGIN;
      final data = {
        "name": name.isNotEmpty ? name : "No Name User",
        "email": email,
      };

      LoggerUtils.logRequest("Google-Login", endpoint, data);

      final res = await dio.post(
        endpoint,
        data: data,
        options: Options(validateStatus: (status) => true),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        LoggerUtils.logSuccess('Google-Login', res.statusCode, res.data);
        final AuthModel authResponse = AuthModel.fromJson(
          res.data as Map<String, dynamic>,
        );

        authLocalSource.setToken(
          authResponse.accessToken,
          authResponse.refreshToken,
        );
        return authResponse;
      } else {
        final msg =
            (res.data is Map<String, dynamic> && res.data['error'] != null)
                ? '${res.data['error'] as String}.'
                : 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      LoggerUtils.logError(
        'Google-Login',
        e is AppException ? e.message : e.toString(),
      );
      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }
}
