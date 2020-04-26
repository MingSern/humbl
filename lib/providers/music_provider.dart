import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class MusicProvider extends ChangeNotifier {
  FlutterAudioQuery audioQuery;
  List<SongInfo> songs;

  MusicProvider() {
    this.audioQuery = FlutterAudioQuery();
    this.getLocalSongs();
  }

  void getLocalSongs() async {
    try {
      this.songs = await this.audioQuery.getSongs();
      this.songs = this.songs.where((song) {
        bool moreThanOneMinute = int.parse(song.duration) >= 60000;
        bool isASong = !song.title.startsWith("AUD") && !song.title.startsWith("Voice");

        return moreThanOneMinute && isASong;
      }).toList();
    } catch (e) {
      print(e.toString());
      this.songs = [];
    }

    notifyListeners();
  }
}
