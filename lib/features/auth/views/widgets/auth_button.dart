import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPress;
  const AuthButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPress,
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
