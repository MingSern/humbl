import 'package:flutter/material.dart';
import 'package:humbl/helpers/palette.dart';
import 'package:humbl/helpers/storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData themeData;

  ThemeProvider() {
    Storage.getBoolean("themeData").then((themeData) {
      if (themeData ?? false) {
        this.toDark();
      } else {
        this.toLight();
      }
    });
  }

  void toLight() {
    this.themeData = ThemeData(
      textSelectionHandleColor: Palette.blue,
      textSelectionColor: Palette.blue.withOpacity(0.2),
      cursorColor: Palette.blue,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Palette.blue,
      primaryTextTheme: TextTheme(
        title: TextStyle(
          color: Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.7,
      ),
    );
    Storage.setBoolean("themeData", false);
    notifyListeners();
  }

  void toDark() {
    this.themeData = ThemeData.dark();
    Storage.setBoolean("themeData", true);
    notifyListeners();
  }
}
