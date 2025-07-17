import 'package:google_sign_in/google_sign_in.dart';

Future<(String, String)> signinWithGoogle() async {
  GoogleSignIn _signin = GoogleSignIn();

  final res = await _signin.signIn();
  if (res != null) {
    final user = (res.displayName!, res.email);
    // print(res.displayName!);
    // print(res.email);
    return user;
  }
  return ("", "");
}
