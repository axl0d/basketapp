import 'package:flutter_bloc/flutter_bloc.dart';

import '../notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService})
    : super(const NotificationInitial()) {
    on<InitializeNotificationsEvent>(_onInitialize);
    on<NotificationReceivedEvent>(_onNotificationReceived);
    on<NotificationOpenedEvent>(_onNotificationOpened);
    on<ClearNotificationEvent>(_onClearNotification);
  }

  Future<void> _onInitialize(
    InitializeNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      notificationService.onForegroundMessage =
          (title, body, orderId, orderStatus) {
            add(
              NotificationReceivedEvent(
                title: title,
                body: body,
                orderId: orderId,
                orderStatus: orderStatus,
              ),
            );
          };

      notificationService.onBackgroundMessage =
          (title, body, orderId, orderStatus) {
            add(
              NotificationOpenedEvent(
                title: title,
                body: body,
                orderId: orderId,
                orderStatus: orderStatus,
              ),
            );
          };

      notificationService.onTerminatedMessage =
          (title, body, orderId, orderStatus) {
            add(
              NotificationOpenedEvent(
                title: title,
                body: body,
                orderId: orderId,
                orderStatus: orderStatus,
              ),
            );
          };

      await notificationService.initialize();
      emit(const NotificationInitial());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      NotificationReceived(
        title: event.title,
        body: event.body,
        orderId: event.orderId,
        orderStatus: event.orderStatus,
      ),
    );
  }

  Future<void> _onNotificationOpened(
    NotificationOpenedEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      NotificationOpened(
        title: event.title,
        body: event.body,
        orderId: event.orderId,
        orderStatus: event.orderStatus,
      ),
    );
  }

  void _onClearNotification(
    ClearNotificationEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(const NotificationInitial());
  }
}
