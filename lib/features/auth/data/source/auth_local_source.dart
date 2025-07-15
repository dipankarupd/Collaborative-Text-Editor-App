import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalSource {
  final SharedPreferences prefs;

  AuthLocalSource({required this.prefs});
  Future<void> setToken(String accessToken, String refreshToken) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("access_token", accessToken);
    await prefs.setString("refresh_token", refreshToken);
  }

  Future<Map<String?, String?>> getTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("access_token");
    String? refreshToken = prefs.getString("refresh_token");

    return {"access_token": accessToken, "refresh_token": refreshToken};
  }

  Future<void> removeTokens() async {
    await prefs.remove("access_token");
    await prefs.remove("refresh_token");
  }
}
