import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:humbl/components/round_button.dart';
import 'package:humbl/helpers/device.dart';
import 'package:humbl/helpers/formatter.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers/player_provider.dart';
import 'package:provider/provider.dart';

class SongDetailScreen extends StatelessWidget {
  final PlayerProvider playerProvider = Provider.of<PlayerProvider>(rootKey.currentContext);

  void next() {
    if (this.playerProvider.hasNext()) {
      return this.playerProvider.next();
    }

    return null;
  }

  void previous() {
    if (this.playerProvider.hasPrevious()) {
      return this.playerProvider.previous();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RoundButton(
          onPressed: () => Device.goBack(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: Text(
                this.playerProvider.selectedSong.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(this.playerProvider.selectedSong.artist ?? ""),
            ),
            StreamBuilder(
              stream: this.playerProvider.durationStream,
              builder: (context, durationSnapshot) {
                return StreamBuilder(
                  stream: this.playerProvider.positionStream,
                  builder: (context, positionSnapshot) {
                    int duration = durationSnapshot?.data?.inMilliseconds ?? 1;
                    int position = positionSnapshot?.data?.inMilliseconds ?? 1;
                    double value = 1000 *
                        (this.playerProvider.currentPosition.inMilliseconds /
                            this.playerProvider.currentDuration.inMilliseconds);

                    if (duration != 1 && position != 1) {
                      value = 1000 * (position / duration);
                      this.playerProvider.setCurrentDuration(durationSnapshot.data);
                      this.playerProvider.setCurrentPosition(positionSnapshot.data);
                    }

                    return Column(
                      children: <Widget>[
                        Slider(
                          value: value,
                          min: 0.0,
                          max: 1000.0,
                          onChanged: null,
                          label: Formatter.getTime(this.playerProvider.currentPosition),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Formatter.getTime(this.playerProvider.currentPosition),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Formatter.getTime(this.playerProvider.currentDuration),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundButton(
                              icon: Icons.skip_previous,
                              onPressed: this.previous,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            this.playerProvider.currentState == AudioPlayerState.PAUSED
                                ? IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    onPressed: this.playerProvider.resume,
                                  )
                                : IconButton(
                                    icon: Icon(Icons.pause),
                                    onPressed: this.playerProvider.pause,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            RoundButton(
                              icon: Icons.skip_next,
                              onPressed: this.next,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
