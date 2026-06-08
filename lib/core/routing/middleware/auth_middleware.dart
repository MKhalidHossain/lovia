import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_status.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final status = Get.find<AuthController>().status.value;
    if (status is Authenticated) return null;
    return const RouteSettings(name: AppRoutes.login);
  }
}
