import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_pages.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_theme.dart';
import 'package:lovia/core/theme/theme_controller.dart';

class LoviaApp extends StatelessWidget {
  const LoviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Lovia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.mode.value,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
