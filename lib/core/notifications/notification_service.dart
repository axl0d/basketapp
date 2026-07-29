import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef MessageHandler = void Function(RemoteMessage message);

const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@drawable/ic_notification');

const DarwinInitializationSettings iosInitSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

const InitializationSettings initSettings = InitializationSettings(
  android: androidInitSettings,
  iOS: iosInitSettings,
);

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  enableLights: true,
  enableVibration: true,
);

const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  'high_importance_channel',
  'High Importance Notifications',
  channelDescription: 'This channel is used for important notifications.',
  importance: Importance.high,
  priority: Priority.high,
  enableLights: true,
  enableVibration: true,
);

const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);

const NotificationDetails platformChannelSpecifics = NotificationDetails(
  android: androidDetails,
  iOS: iosDetails,
);

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late final FlutterLocalNotificationsPlugin _localNotifications;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal() {
    _localNotifications = FlutterLocalNotificationsPlugin();
  }

  Future<void> initialize() async {
    try {
      await _initializeLocalNotifications();
      await _setupFCMListeners();
      await _checkInitialMessage();
      await getDeviceToken();

      if (kDebugMode) {
        print('NotificationService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
    }
  }

  Future<void> _initializeLocalNotifications() async {
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            if (kDebugMode) {
              print('onDidReceiveNotificationResponse: $notificationResponse');
            }
          },
    );
    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _setupFCMListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundMessage(message);
    });
  }

  Future<void> _checkInitialMessage() async {
    final RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      _handleTerminatedMessage(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
    }

    final notification = message.notification;
    if (notification != null) {
      showLocalNotification(
        title: notification.title ?? 'Notificación',
        body: notification.body ?? '',
      );
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
    }
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('App opened from terminated state: ${message.messageId}');
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    try {
      await _localNotifications.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing local notification: $e');
      }
    }
  }

  Future<String?> getDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (kDebugMode && token != null) {
        print('FCM Device Token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
      return null;
    }
  }

  Future<void> requestPermissions() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permissions: $e');
      }
    }
  }
}
