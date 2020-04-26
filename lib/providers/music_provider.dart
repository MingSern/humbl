import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class MusicProvider extends ChangeNotifier {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs;

  MusicProvider() {
    this.getLocalSongs();
  }

  void getLocalSongs() async {
    try {
      this.songs = await audioQuery.getSongs();
    } catch (e) {
      print(e.toString());
      this.songs = [];
    }

    notifyListeners();
  }
}
