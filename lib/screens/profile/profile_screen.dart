import 'package:flutter/material.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final ThemeProvider themeProvider = Provider.of<ThemeProvider>(rootKey.currentContext);

  void toDark() {
    this.themeProvider.toDark();
  }

  void toLight() {
    this.themeProvider.toLight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Text("Profile"),
          RaisedButton(
            color: Colors.black87,
            child: Text(
              "Dark",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: this.toDark,
          ),
          RaisedButton(
            color: Colors.white,
            child: Text(
              "Light",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: this.toLight,
          ),
        ],
      )),
    );
  }
}
