import 'package:basketapp/app/app.dart';
import 'package:basketapp/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
