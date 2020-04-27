import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class PlayerProvider extends ChangeNotifier {
  AudioPlayer player;
  List<SongInfo> songs;
  SongInfo selectedSong;
  Stream<Duration> durationStream;
  Stream<Duration> positionStream;
  Duration currentPosition;
  Duration currentDuration;
  AudioPlayerState currentState;

  PlayerProvider() {
    this.player = AudioPlayer();
    this.currentPosition = Duration(milliseconds: 1);
    this.currentDuration = Duration(milliseconds: 29000);
    this.setupStreams();
  }

  void update(List<SongInfo> songs) {
    this.songs = songs;
    notifyListeners();
  }

  void setupStreams() {
    this.durationStream = this.player.onDurationChanged;
    this.positionStream = this.player.onAudioPositionChanged;
  }

  void setCurrentPosition(Duration currentPosition) {
    this.currentPosition = currentPosition;
  }

  void setCurrentDuration(Duration currentDuration) {
    this.currentDuration = currentDuration;
  }

  void setCurrentState(AudioPlayerState currentState) {
    this.currentState = currentState;
  }

  void clear() {
    this.selectedSong = null;
    this.currentPosition = Duration(milliseconds: 1);
    this.currentDuration = Duration(milliseconds: 29000);
  }

  void open(SongInfo selectedSong) {
    this.selectedSong = selectedSong;
    this.play(selectedSong.filePath);
  }

  Future<void> play(String filePath) async {
    await this.player.play(filePath, isLocal: true);
    this.setCurrentState(AudioPlayerState.PLAYING);
    notifyListeners();
  }

  void resume() {
    this.player.resume();
    this.setCurrentState(AudioPlayerState.PLAYING);
    notifyListeners();
  }

  void pause() {
    this.player.pause();
    this.setCurrentState(AudioPlayerState.PAUSED);
    notifyListeners();
  }

  void stop() {
    this.player.stop();
    this.setCurrentState(AudioPlayerState.STOPPED);
    this.clear();
    notifyListeners();
  }

  void next() {
    int currentIndex = this.songs.indexOf(this.selectedSong);
    int nextIndex = currentIndex + 1;
    SongInfo nextSong = this.songs[nextIndex];
    this.open(nextSong);
  }

  bool hasNext() {
    return this.selectedSong != this.songs.last;
  }

  void previous() {
    int currentIndex = this.songs.indexOf(this.selectedSong);
    int previousIndex = currentIndex - 1;
    SongInfo previousSong = this.songs[previousIndex];
    this.open(previousSong);
  }

  bool hasPrevious() {
    return this.selectedSong != this.songs.first;
  }

  void onSeek(double value) {
    Duration position = Duration(
      milliseconds: ((value / 1000) * this.currentDuration.inMilliseconds).round(),
    );
    this.setCurrentPosition(position);
    // notifyListeners();
  }

  void onSeekEnd() async {
    await this.player.seek(this.currentPosition);
    // notifyListeners();
  }
}
