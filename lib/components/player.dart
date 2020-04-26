import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:humbl/components/round_button.dart';
import 'package:humbl/helpers/palette.dart';

class Player extends StatelessWidget {
  final Function onDismissed;
  final VoidCallback onResume;
  final VoidCallback onPause;
  final SongInfo selectedSong;
  final Stream<Duration> duration;
  final Stream<Duration> position;
  final Stream<AudioPlayerState> state;
  final Duration currentDuration;
  final Duration currentPosition;
  final Function onDurationChanged;
  final Function onPositionChanged;
  final GestureTapCallback onTap;
  final double height = 60;

  Player({
    @required this.onDismissed,
    @required this.onResume,
    @required this.onPause,
    @required this.selectedSong,
    @required this.duration,
    @required this.position,
    @required this.state,
    @required this.currentDuration,
    @required this.currentPosition,
    @required this.onDurationChanged,
    @required this.onPositionChanged,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.state,
      builder: (context, stateSnapshot) {
        return stateSnapshot.data == AudioPlayerState.STOPPED || this.selectedSong == null
            ? Container()
            : Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.down,
                onDismissed: (_) => this.onDismissed(),
                child: GestureDetector(
                  onTap: this.onTap,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: this.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: this.height,
                            height: this.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: this.selectedSong?.albumArtwork != null
                                ? Image.file(
                                    File(this.selectedSong.albumArtwork),
                                    fit: BoxFit.contain,
                                  )
                                : Icon(Icons.music_note),
                          ),
                          StreamBuilder(
                            stream: this.duration,
                            builder: (context, durationSnapshot) {
                              return StreamBuilder(
                                stream: this.position,
                                builder: (context, positionSnapshot) {
                                  int duration = durationSnapshot?.data?.inMilliseconds ?? 1;
                                  int position = positionSnapshot?.data?.inMilliseconds ?? 1;
                                  double width = 290 *
                                      (this.currentPosition.inMilliseconds /
                                          this.currentDuration.inMilliseconds);

                                  if (duration != 1 && position != 1) {
                                    width = 290 * (position / duration);
                                    this.onDurationChanged(durationSnapshot.data);
                                    this.onPositionChanged(positionSnapshot.data);
                                  }

                                  return Stack(
                                    children: <Widget>[
                                      AnimatedContainer(
                                        color: Palette.blue.withOpacity(0.2),
                                        height: this.height,
                                        width: width,
                                        duration: Duration(milliseconds: 150),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 230,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(
                                              this.selectedSong?.title ?? "Opps",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            height: this.height,
                                            width: this.height,
                                            child: stateSnapshot.data == AudioPlayerState.PLAYING
                                                ? RoundButton(
                                                    icon: Icons.pause,
                                                    onPressed: this.onPause,
                                                  )
                                                : RoundButton(
                                                    icon: Icons.play_arrow,
                                                    onPressed: this.onResume,
                                                  ),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
