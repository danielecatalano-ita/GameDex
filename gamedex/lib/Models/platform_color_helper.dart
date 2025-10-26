import 'package:flutter/material.dart';

class PlatformColorHelper {
  static Color getColor(String? platformName) {
    switch (platformName?.toLowerCase()) {
      case "playstation":
        return Colors.blue;
      case "xbox":
        return Colors.green;
      case "nintendo":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
