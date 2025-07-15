import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  const UserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blue.shade100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'user.png',
            width: 36,
            height: 36,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, color: Colors.blue.shade700, size: 20);
            },
          ),
        ),
      ),
    );
  }
}
