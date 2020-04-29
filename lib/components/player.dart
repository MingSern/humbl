import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:humbl/components/round_button.dart';
import 'package:humbl/helpers/palette.dart';
import 'package:humbl/providers/player_provider.dart';

class Player extends StatefulWidget {
  final PlayerProvider provider;
  final GestureTapCallback onTap;

  Player({
    @required this.provider,
    @required this.onTap,
  });

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final double height = 60;
  double offset;

  @override
  void initState() {
    this.offset = 0;
    super.initState();
  }

  Future<void> onDrag(DragEndDetails drag) async {
    if (drag.primaryVelocity < 0 && this.widget.provider.hasNext()) {
      setState(() => this.offset = 1);
      this.widget.provider.next(isSliding: true);
    } else if (drag.primaryVelocity > 0 && this.widget.provider.hasPrevious()) {
      setState(() => this.offset = -1);
      this.widget.provider.previous(isSliding: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.provider.currentState == AudioPlayerState.STOPPED ||
            this.widget.provider.selectedSong == null
        ? Container()
        : Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.down,
            onDismissed: (_) => this.widget.provider.stop(),
            child: GestureDetector(
              onTap: this.widget.onTap,
              onHorizontalDragEnd: this.onDrag,
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
                        child: this.widget.provider.selectedSong?.albumArtwork != null
                            ? Image.file(
                                File(this.widget.provider.selectedSong.albumArtwork),
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.music_note),
                      ),
                      StreamBuilder(
                        stream: this.widget.provider.durationStream,
                        builder: (context, durationSnapshot) {
                          return StreamBuilder(
                            stream: this.widget.provider.positionStream,
                            builder: (context, positionSnapshot) {
                              Duration currentDuration = this.widget.provider.currentDuration;
                              Duration currentPosition = this.widget.provider.currentPosition;
                              int duration = durationSnapshot?.data?.inMilliseconds ?? 1;
                              int position = positionSnapshot?.data?.inMilliseconds ?? 1;
                              double width =
                                  290 * (currentPosition.inMilliseconds / currentDuration.inMilliseconds);

                              if (duration != 1 && position != 1) {
                                width = 290 * (position / duration);
                                this.widget.provider.setCurrentDuration(durationSnapshot.data);
                                this.widget.provider.setCurrentPosition(positionSnapshot.data);
                              }

                              AudioPlayerState state = this.widget.provider.currentState;

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
                                      !this.widget.provider.isSliding
                                          ? Container(
                                              width: 230,
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(
                                                this.widget.provider.selectedSong.title,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : ClipRRect(
                                              child: AnimatedSwitcher(
                                                duration: Duration(milliseconds: 300),
                                                transitionBuilder:
                                                    (Widget child, Animation<double> animation) {
                                                  final inAnimation = Tween<Offset>(
                                                    begin: Offset(this.offset, 0),
                                                    end: Offset(0, 0),
                                                  ).animate(animation);

                                                  final outAnimation = Tween<Offset>(
                                                    begin: Offset(-this.offset, 0),
                                                    end: Offset(0, 0),
                                                  ).animate(animation);

                                                  return ClipRRect(
                                                    child: SlideTransition(
                                                      position:
                                                          child.key == Key("A") ? inAnimation : outAnimation,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  key: positionSnapshot.hasData ? Key("A") : Key("B"),
                                                  width: 230,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Text(
                                                    positionSnapshot.hasData
                                                        ? this.widget.provider.selectedSong.title
                                                        : this.widget.provider.prevSelectedSong.title,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      Container(
                                        height: this.height,
                                        width: this.height,
                                        child: state == AudioPlayerState.PLAYING
                                            ? RoundButton(
                                                icon: Icons.pause,
                                                onPressed: this.widget.provider.pause,
                                              )
                                            : RoundButton(
                                                icon: Icons.play_arrow,
                                                onPressed: this.widget.provider.resume,
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
