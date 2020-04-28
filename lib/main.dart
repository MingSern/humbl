import 'package:flutter/material.dart';
import 'package:humbl/helpers/palette.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers.dart';
import 'package:humbl/providers/theme_provider.dart';
import 'package:humbl/routes.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: ProvidersInjectedApp(),
    );
  }
}

class ProvidersInjectedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      key: rootKey,
      title: "humbl",
      color: Palette.sesame,
      theme: themeProvider.themeData,
      initialRoute: "/index",
      routes: routes,
    );
  }
}
