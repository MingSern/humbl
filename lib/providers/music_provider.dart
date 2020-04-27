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
        bool isMp3 = song.isMusic;
        bool moreThanOneMinute = int.parse(song.duration) >= 60000;
        bool isSong = !song.title.startsWith("AUD") && !song.title.startsWith("Voice");

        return moreThanOneMinute && isSong && isMp3;
      }).toList();
    } catch (e) {
      print(e.toString());
      this.songs = [];
    }

    notifyListeners();
  }
}
