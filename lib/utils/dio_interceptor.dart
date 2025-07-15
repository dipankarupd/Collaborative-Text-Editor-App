// import 'package:app/config/constants/endpoints.dart';
// import 'package:app/features/auth/data/source/auth_local_source.dart';
// import 'package:dio/dio.dart';

// class TokenInterceptor extends Interceptor {
//   final Dio _dio;
//   final AuthLocalSource _authLocalSource;

//   TokenInterceptor({required Dio dio, required AuthLocalSource authLocalSource})
//     : _dio = dio,
//       _authLocalSource = authLocalSource;

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final tokens = await _authLocalSource.getTokens();
//     final accessToken = tokens['access_token'];

//     if (accessToken != null && accessToken.isNotEmpty) {
//       options.headers["token"] = accessToken;
//     }

//     return handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     final requestOption = err.requestOptions;

//     final isTokenExpired =
//         err.response?.statusCode == 401 &&
//         err.response?.data["error"] == "TOKEN EXPIRED";

//     // LoggerUtils.logGeneral("$isTokenExpired");

//     if (isTokenExpired) {
//       final tokens = await _authLocalSource.getTokens();
//       // final refreshToken = tokens["refresh_token"];

//       // print(refreshToken);
//       final refreshToken =
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoidXNlcjEiLCJFbWFpbCI6InVzZXIxQGdtYWlsLmNvbSIsIlVzZXJJZCI6ImJhNGNiMTE0LTY4MjAtNDgzOC05YzU5LTVlNWQ5OWMyZmYyNiIsImV4cCI6MTc1MTE4NDUxMX0.MZk4e_4pKFKqaR25lDVtsaxhYP4MeEdUooTDEprmv2Y';
//       if (refreshToken != null && refreshToken.isNotEmpty) {
//         try {
//           final refreshResponse = await _dio.get(
//             AppEndpoints.REFRESH,
//             options: Options(headers: {"refresh-token": refreshToken}),
//           );

//           if (refreshResponse.statusCode == 200) {
//             final newAccessToken = refreshResponse.data["access_token"];
//             final newRefreshToken = refreshResponse.data["refresh_token"];

//             await _authLocalSource.setToken(newAccessToken, newRefreshToken);

//             // Clone request with new access token
//             requestOption.headers["token"] = newAccessToken;

//             final clonedResponse = await _dio.fetch(requestOption);
//             return handler.resolve(clonedResponse);
//           }
//         } catch (e) {
//           // Log or handle refresh failure if needed
//           return handler.reject(err);
//         }
//       }
//     }
//   }
// }
import 'package:app/common/exceptions/app_exception.dart';
import 'package:app/config/constants/endpoints.dart';
import 'package:app/features/auth/data/source/auth_local_source.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  final AuthLocalSource _authLocalSource;

  TokenInterceptor({required Dio dio, required AuthLocalSource authLocalSource})
    : _dio = dio,
      _authLocalSource = authLocalSource;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokens = await _authLocalSource.getTokens();
    final accessToken = tokens['access_token'];

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers["token"] = accessToken;
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOption = err.requestOptions;

    final isTokenExpired =
        err.response?.statusCode == 401 &&
        err.response?.data["error"] == "TOKEN EXPIRED";

    if (isTokenExpired) {
      final tokens = await _authLocalSource.getTokens();
      final refreshToken = tokens["refresh_token"];
      print(refreshToken);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final refreshResponse = await _dio.get(
            AppEndpoints.REFRESH,
            options: Options(headers: {"refresh-token": refreshToken}),
          );

          if (refreshResponse.statusCode == 200) {
            final newAccessToken = refreshResponse.data["access_token"];
            final newRefreshToken = refreshResponse.data["refresh_token"];

            await _authLocalSource.setToken(newAccessToken, newRefreshToken);

            // Clone request with new access token
            requestOption.headers["token"] = newAccessToken;

            final clonedResponse = await _dio.fetch(requestOption);
            return handler.resolve(clonedResponse);
          }
        } catch (e) {
          // Token refresh failed - user needs to login again
          // Convert to AppException so your existing error handling works
          final appException = AppException(
            message: "Session expired. Please login again.",
          );
          return handler.reject(
            DioException(
              requestOptions: requestOption,
              error: appException,
              type: DioExceptionType.unknown,
            ),
          );
        }
      }

      // No refresh token available
      final appException = AppException(
        message: "Session expired. Please login again.",
      );
      return handler.reject(
        DioException(
          requestOptions: requestOption,
          error: appException,
          type: DioExceptionType.unknown,
        ),
      );
    }

    // For non-token related errors, pass through
    return handler.next(err);
  }
}
