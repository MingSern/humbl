import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int index;

  NavigationProvider() {
    this.index = 0;
  }

  setIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
