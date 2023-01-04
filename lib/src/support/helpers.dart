import 'dart:convert';
import 'package:crypto/crypto.dart';

class Helpers {
  static String generateMd5(String string) {
    List<int> utfInput = utf8.encode(string);

    return md5.convert(utfInput).toString();
  }

  static int convertToInt(dynamic value) {
    if (value.runtimeType == String) {
      value = int.parse(value);
    }

    return value;
  }

  static double convertToDouble(dynamic value) {
    if (value.runtimeType == double) {
      return value;
    }

    return value.toDouble();
  }

  static int now() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}