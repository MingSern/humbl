import 'package:flutter/material.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers/player_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final PlayerProvider playerProvider = Provider.of<PlayerProvider>(rootKey.currentContext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: this.playerProvider.stop,
      ),
    );
  }
}
