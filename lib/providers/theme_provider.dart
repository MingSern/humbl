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
      textSelectionHandleColor: Palette.sesame,
      textSelectionColor: Palette.sesame.withOpacity(0.2),
      cursorColor: Palette.sesame,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Palette.tomato,
      primaryTextTheme: TextTheme(
        title: TextStyle(
          color: Palette.sesame,
        ),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          color: Palette.sesame,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.7,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Palette.sesame,
      ),
      accentIconTheme: IconThemeData(
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Palette.sesame,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Palette.sesame,
        inactiveTrackColor: Palette.sesame.withOpacity(0.2),
        thumbColor: Palette.tomato,
        overlayColor: Palette.tomato.withOpacity(0.2),
        valueIndicatorColor: Palette.tomato,
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
