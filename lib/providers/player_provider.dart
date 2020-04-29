import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class PlayerProvider extends ChangeNotifier {
  AudioPlayer player;
  List<SongInfo> songs;
  SongInfo selectedSong;
  SongInfo prevSelectedSong;
  Stream<Duration> durationStream;
  Stream<Duration> positionStream;
  Duration currentPosition;
  Duration currentDuration;
  AudioPlayerState currentState;
  bool isSliding;

  PlayerProvider() {
    this.player = AudioPlayer();
    this.currentPosition = Duration(milliseconds: 1);
    this.currentDuration = Duration(milliseconds: 29000);
    this.isSliding = false;
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

    if (this.currentPosition.inSeconds >= this.currentDuration.inSeconds) {
      this.setCurrentState(AudioPlayerState.PAUSED);
      this.next();
    }
  }

  void setCurrentDuration(Duration currentDuration) {
    this.currentDuration = currentDuration;
  }

  void setCurrentState(AudioPlayerState currentState) {
    this.currentState = currentState;
  }

  void setIsSliding(bool isSliding) {
    this.isSliding = isSliding;
  }

  void clear() {
    this.selectedSong = null;
    this.prevSelectedSong = null;
    this.isSliding = false;
    this.currentPosition = Duration(milliseconds: 1);
    this.currentDuration = Duration(milliseconds: 29000);
  }

  void open(SongInfo selectedSong, {bool isSliding = false}) {
    this.prevSelectedSong = this.selectedSong ?? selectedSong;
    this.selectedSong = selectedSong;
    this.currentPosition = Duration(milliseconds: 1);
    this.setIsSliding(isSliding);
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
    this.setIsSliding(false);
    notifyListeners();
  }

  void pause() {
    this.player.pause();
    this.setCurrentState(AudioPlayerState.PAUSED);
    this.setIsSliding(false);
    notifyListeners();
  }

  void stop() {
    this.player.stop();
    this.setCurrentState(AudioPlayerState.STOPPED);
    this.clear();
    notifyListeners();
  }

  void next({bool isSliding = false}) {
    int currentIndex = this.songs.indexOf(this.selectedSong);
    int nextIndex = currentIndex + 1;
    SongInfo nextSong = this.songs[nextIndex];
    this.open(nextSong, isSliding: isSliding);
  }

  bool hasNext() {
    return this.selectedSong != this.songs.last;
  }

  void previous({bool isSliding = false}) {
    int currentIndex = this.songs.indexOf(this.selectedSong);
    int previousIndex = currentIndex - 1;
    SongInfo previousSong = this.songs[previousIndex];
    this.open(previousSong, isSliding: isSliding);
  }

  bool hasPrevious() {
    return this.selectedSong != this.songs.first;
  }

  void onSeek(double value) async {
    Duration position = Duration(milliseconds: value.toInt());
    this.setCurrentPosition(position);
    await this.player.seek(this.currentPosition);
  }
}
