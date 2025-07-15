import 'package:flutter/material.dart';

class SigninWithGoogleButton extends StatelessWidget {
  final double w;
  final double h;
  final VoidCallback onPress;
  const SigninWithGoogleButton({
    super.key,
    required this.w,
    required this.h,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress,
      label: Text('Sign in With Google'),
      icon: Image.asset('google.png', height: 20),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(w, h),
      ),
    );
  }
}
