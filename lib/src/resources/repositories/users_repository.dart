import 'dart:async';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersRepository {
  static UsersRepository? _instance;

  Future<User> getCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();

    return User(
      preferences.getString('user.first_name') ?? '',
      preferences.getString('user.last_name') ?? '',
      preferences.getString('user.username') ?? ''
    );
  }

  Future setCurrentUser(User user) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString('user.first_name', user.fistName);
    await preferences.setString('user.last_name', user.lastName);
    await preferences.setString('user.username', user.userName);
  }

  Future resetCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove('user.first_name');
    await preferences.remove('user.last_name');
    await preferences.remove('user.username');
  }

  factory UsersRepository.getInstance() => _instance ??= UsersRepository._internal();

  UsersRepository._internal();
}