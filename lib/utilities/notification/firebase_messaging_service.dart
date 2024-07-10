import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getFirebaseToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token ?? '';
  }

  void configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received message: ${message.notification?.body}');
      // Xử lý thông báo được nhận khi ứng dụng đang chạy
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked!');
      // Xử lý thông báo khi người dùng nhấp vào thông báo khi ứng dụng đang chạy
    });
  }
}
