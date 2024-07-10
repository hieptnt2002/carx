import 'package:flutter/material.dart';

class NotificationScreeen extends StatelessWidget {
  const NotificationScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/no-notify.png',
          width: 166,
          height: 166,
        ),
      ),
    );
  }
}
