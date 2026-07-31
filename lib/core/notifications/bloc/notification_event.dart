import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNotificationsEvent extends NotificationEvent {
  const InitializeNotificationsEvent();
}

class NotificationReceivedEvent extends NotificationEvent {
  const NotificationReceivedEvent({
    required this.title,
    required this.body,
    required this.orderId,
    required this.orderStatus,
  });

  final String title;
  final String body;
  final String orderId;
  final String orderStatus;

  @override
  List<Object?> get props => [title, body, orderId, orderStatus];
}

class NotificationOpenedEvent extends NotificationEvent {
  const NotificationOpenedEvent({
    required this.title,
    required this.body,
    required this.orderId,
    required this.orderStatus,
  });

  final String title;
  final String body;
  final String orderId;
  final String orderStatus;

  @override
  List<Object?> get props => [title, body, orderId, orderStatus];
}

class ClearNotificationEvent extends NotificationEvent {
  const ClearNotificationEvent();
}
