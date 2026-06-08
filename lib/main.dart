import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lovia/app/app.dart';
import 'package:lovia/app/di/app_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  AppBindings().dependencies();
  runApp(const LoviaApp());
}
