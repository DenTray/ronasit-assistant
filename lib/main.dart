import 'package:flutter/material.dart';
import 'package:ronas_assistant/src/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    App(preferences: preferences)
  );
}