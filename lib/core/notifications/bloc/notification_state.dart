import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationReceived extends NotificationState {
  const NotificationReceived({
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

class NotificationOpened extends NotificationState {
  const NotificationOpened({
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

class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
