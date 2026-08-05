import 'dart:async';
import 'dart:developer';

import 'package:basketapp/core/database/hive_config.dart';
import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/core/notifications/bloc/notification_bloc.dart';
import 'package:basketapp/core/notifications/bloc/notification_event.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // App initialization
  await Firebase.initializeApp();
  await initHive();
  await setupServiceLocator();

  getIt<NotificationBloc>().add(const InitializeNotificationsEvent());

  runApp(await builder());
}
