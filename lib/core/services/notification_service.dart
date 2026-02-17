import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Background notification tap handler
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _isInitialized = false;

  /// Initialize the notification service
  static Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Initialize timezones
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Paris'));
    } catch (e) {
      tz.initializeTimeZones(); // Fallback
    }
    
    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    // Combined settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    try {
      // Initialize plugin
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
      
      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _createNotificationChannel();
      }
      
      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'movie_reminders',
      'Movie Reminders',
      description: 'Notifications pour les rappels de films',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    try {
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      // Channel creation error handled silently
    }
  }

  /// Handle notification tap when app is running
  static void _onNotificationTap(NotificationResponse response) {
    // Handle foreground notification tap
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Use permission_handler for Android 13+
        final status = await Permission.notification.request();
        return status.isGranted;
      } else if (Platform.isIOS) {
        final iosPlugin = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if permissions are granted
  static Future<bool> hasPermissions() async {

    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        return status.isGranted;
      } else if (Platform.isIOS) {

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> showTestNotification() async {    
   
    if (!_isInitialized) {
      await init();
    }

    bool hasPerms = await hasPermissions();
    if (!hasPerms) {
      hasPerms = await requestPermissions();
      if (!hasPerms) {
        throw Exception('Notification permissions denied');
      }
    }
    

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'movie_reminders',
      'Movie Reminders',
      channelDescription: 'Test notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        999,
        '🎬 Test MobMovizz',
        'Si vous voyez cette notification, ça marche !',
        details,
        payload: 'test',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Schedule a movie reminder notification
  static Future<void> scheduleMovieReminder({
    required int movieId,
    required String movieTitle,
    required DateTime reminderDateTime,
    String? notificationTitle,
    String? notificationBody,
  }) async {
    
    if (!_isInitialized) {
      await init();
    }

    if (reminderDateTime.isBefore(DateTime.now())) {
      return;
    }

    final hasPerms = await hasPermissions();
    if (!hasPerms) {
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'movie_reminders',
      'Movie Reminders',
      channelDescription: 'Rappels de films',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use provided messages or fallback to defaults
    final title = notificationTitle ?? '🎬 Rappel MobMovizz';
    final body = notificationBody ?? 'N\'oubliez pas le film "$movieTitle" !';

    try {
      await _notifications.zonedSchedule(
        movieId,
        title,
        body,
        tz.TZDateTime.from(reminderDateTime, tz.local),
        details,
        payload: 'movie_$movieId',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending = await _notifications.pendingNotificationRequests();
      return pending;
    } catch (e) {
      return [];
    }
  }

  /// Cancel a notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}