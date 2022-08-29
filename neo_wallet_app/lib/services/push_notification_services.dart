import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServices with ChangeNotifier {
  FirebaseMessaging _firebaseMessagin = FirebaseMessaging.instance;

  initNotification() {
    _firebaseMessagin.requestPermission();

    _firebaseMessagin.getToken().then((token) {
      print(token);
    });
  }
}
