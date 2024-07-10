import 'package:carx/utilities/api_constants.dart';
import 'package:dio/dio.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<void> sendNotificationToAllDevices(String title, String body) async {
    await _dio.post(
      FCM_END_POINT,
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$FIREBASE_SEVER_KEY',
        },
      ),
      data: {
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'sound': 'default',
        },
        'to': '/topics/all',
      },
    );
  }

  Future<void> sendNotificationToDevice(
      String token, String title, String body) async {
    await _dio.post(
      FCM_END_POINT,
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$FIREBASE_SEVER_KEY',
        },
      ),
      data: {
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'sound': 'default',
        },
        'to': token,
      },
    );
  }
}
