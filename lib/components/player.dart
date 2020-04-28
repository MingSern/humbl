import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:humbl/components/round_button.dart';
import 'package:humbl/helpers/palette.dart';
import 'package:humbl/providers/player_provider.dart';

class Player extends StatelessWidget {
  final PlayerProvider provider;
  final GestureTapCallback onTap;
  final double height = 60;

  Player({
    @required this.provider,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return this.provider.currentState == AudioPlayerState.STOPPED || this.provider.selectedSong == null
        ? Container()
        : Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.down,
            onDismissed: (_) => this.provider.stop(),
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
                        child: this.provider.selectedSong?.albumArtwork != null
                            ? Image.file(
                                File(this.provider.selectedSong.albumArtwork),
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.music_note),
                      ),
                      StreamBuilder(
                        stream: this.provider.durationStream,
                        builder: (context, durationSnapshot) {
                          return StreamBuilder(
                            stream: this.provider.positionStream,
                            builder: (context, positionSnapshot) {
                              Duration currentDuration = this.provider.currentDuration;
                              Duration currentPosition = this.provider.currentPosition;
                              int duration = durationSnapshot?.data?.inMilliseconds ?? 1;
                              int position = positionSnapshot?.data?.inMilliseconds ?? 1;
                              double width =
                                  290 * (currentPosition.inMilliseconds / currentDuration.inMilliseconds);

                              if (duration != 1 && position != 1) {
                                width = 290 * (position / duration);
                                this.provider.setCurrentDuration(durationSnapshot.data);
                                this.provider.setCurrentPosition(positionSnapshot.data);
                              }

                              return Stack(
                                children: <Widget>[
                                  AnimatedContainer(
                                    color: Palette.tomato.withOpacity(0.2),
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
                                          this.provider.selectedSong?.title ?? "Ops!",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        height: this.height,
                                        width: this.height,
                                        child: this.provider.currentState == AudioPlayerState.PLAYING
                                            ? RoundButton(
                                                icon: Icons.pause,
                                                onPressed: this.provider.pause,
                                              )
                                            : RoundButton(
                                                icon: Icons.play_arrow,
                                                onPressed: this.provider.resume,
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
  }
}
