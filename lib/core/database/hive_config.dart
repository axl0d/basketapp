import 'package:hive_flutter/hive_flutter.dart';
import 'package:basketapp/core/database/hive_boxes.dart';
import 'package:basketapp/features/orders/data/models/order_hive_model.dart';
import 'package:basketapp/features/orders/data/models/cart_item_hive_model.dart';
import 'package:basketapp/features/orders/data/models/order_status_hive_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(OrderStatusHiveModelAdapter());
  Hive.registerAdapter(CartItemHiveModelAdapter());
  Hive.registerAdapter(OrderHiveModelAdapter());

  await Hive.openBox<OrderHiveModel>(HiveBoxes.orders);
}
