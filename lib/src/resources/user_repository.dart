import 'dart:async';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static UserRepository? _instance;

  Future<User> getUser() async {
    final preferences = await SharedPreferences.getInstance();

    return User(
      preferences.getString('user.first_name') ?? '',
      preferences.getString('user.last_name') ?? '',
      preferences.getString('user.username') ?? ''
    );
  }

  Future setUser(String firstName, String lastName, String userName) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString('user.first_name', firstName);
    await preferences.setString('user.last_name', lastName);
    await preferences.setString('user.username', userName);
  }

  Future removeUser() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove('user.first_name');
    await preferences.remove('user.last_name');
    await preferences.remove('user.username');
  }

  factory UserRepository.getInstance() => _instance ??= UserRepository._internal();

  UserRepository._internal();
}