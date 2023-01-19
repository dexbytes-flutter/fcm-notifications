import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int notificationCount;
  const NotificationBadge({Key? key,required this.notificationCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
          color: Colors.red,
        shape: BoxShape.circle
      ),
      child: Center(child: Text('$notificationCount'),),
    );
  }
}
