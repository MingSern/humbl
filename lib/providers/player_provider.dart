import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class PlayerProvider extends ChangeNotifier {
  AudioPlayer player;
  SongInfo selectedSong;
  Stream<Duration> durationStream;
  Stream<Duration> positionStream;
  Stream<AudioPlayerState> stateStream;
  Duration currentPosition;
  Duration currentDuration;

  PlayerProvider() {
    this.player = AudioPlayer();
    this.currentPosition = Duration(milliseconds: 100);
    this.currentDuration = Duration(milliseconds: 100);
    this.setupStreams();
  }

  void open(SongInfo selectedSong) {
    this.selectedSong = selectedSong;
    this.play(selectedSong.filePath);
    notifyListeners();
  }

  Future<void> play(String filePath) async {
    await this.player.play(filePath, isLocal: true);
    this.setupStreams();
  }

  void resume() {
    this.player.resume();
    notifyListeners();
  }

  void pause() {
    this.player.pause();
    notifyListeners();
  }

  void stop() {
    this.player.stop();
    this.clear();
  }

  void setupStreams() {
    this.durationStream = this.player.onDurationChanged;
    this.positionStream = this.player.onAudioPositionChanged;
    this.stateStream = this.player.onPlayerStateChanged;
    notifyListeners();
  }

  void setCurrentPosition(Duration currentPosition) {
    this.currentPosition = currentPosition;
  }

  void setCurrentDuration(Duration currentDuration) {
    this.currentDuration = currentDuration;
  }

  void clear() {
    this.selectedSong = null;
    this.currentPosition = Duration(milliseconds: 100);
    this.currentDuration = Duration(milliseconds: 100);
    notifyListeners();
  }
}
