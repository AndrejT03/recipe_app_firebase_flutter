import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  Timer? _timer;
  Function()? _onNotificationTap;

  Future<void> init({Function()? onNotificationTap}) async {
    _onNotificationTap = onNotificationTap;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        _onNotificationTap?.call();
      },
    );

    if (Platform.isAndroid) {
      final androidImpl =
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    }
  }

  void start30sNotifications() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _showRandomRecipeNotification();
    });
  }

  void stop30sNotifications() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _showRandomRecipeNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'recipe_30s_channel',
      'Recipe 30s',
      channelDescription: 'Demo notifications every 30s',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      0,
      'Recipe every 30 seconds',
      'Click for the recipe!',
      notificationDetails,
      payload: 'random_recipe',
    );
  }
}