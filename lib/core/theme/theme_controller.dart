import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/constants/storage_keys.dart';

class ThemeController extends GetxController {
  ThemeController(this._box);
  final GetStorage _box;

  final Rx<ThemeMode> mode = ThemeMode.dark.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = _box.read<String>(StorageKeys.themeMode);
    mode.value = switch (stored) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  bool get isDark => mode.value == ThemeMode.dark;

  void toggleDark({required bool dark}) {
    mode.value = dark ? ThemeMode.dark : ThemeMode.light;
    _box.write(StorageKeys.themeMode, dark ? 'dark' : 'light');
  }
}
