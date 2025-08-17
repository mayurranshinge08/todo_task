
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String settingsBox = 'settingsBox';
  static const String keyIsDark = 'isDark';

  ThemeCubit() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final box = await _openBox();
    final isDark = box.get(keyIsDark, defaultValue: false) as bool;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggle() async {
    final box = await _openBox();
    final newMode =
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await box.put(keyIsDark, newMode == ThemeMode.dark);
    emit(newMode);
  }

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(settingsBox)) return Hive.box(settingsBox);
    return await Hive.openBox(settingsBox);
  }
}
