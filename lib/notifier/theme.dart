import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MonTheme extends ChangeNotifier {
  static String mode = "Jour";
  void setMode(String m) {
    mode = m;
    notifyListeners();
  }

  ThemeData getTheme() {
    return (mode == "Jour") ? ThemeData.light() : ThemeData.dark();
  }
}
