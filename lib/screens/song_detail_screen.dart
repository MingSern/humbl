import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:humbl/components/round_button.dart';
import 'package:humbl/helpers/device.dart';
import 'package:humbl/helpers/formatter.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers/player_provider.dart';
import 'package:provider/provider.dart';

class SongDetailScreen extends StatefulWidget {
  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final PlayerProvider playerProvider = Provider.of<PlayerProvider>(rootKey.currentContext);
  double sliderValue;
  bool isChanging;

  @override
  void initState() {
    this.sliderValue = this.playerProvider.currentPosition.inMilliseconds.toDouble();
    this.isChanging = false;
    super.initState();
  }

  void sliderOnChanged(double value) {
    setState(() {
      this.isChanging = true;
      this.sliderValue = value;
    });
  }

  void sliderChangeEnd(double value) {
    this.playerProvider.onSeek(value);
    setState(() => this.isChanging = false);
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
              stream: this.playerProvider.positionStream,
              builder: (context, positionSnapshot) {
                return Column(
                  children: <Widget>[
                    Slider(
                      value: this.isChanging
                          ? this.sliderValue
                          : this.playerProvider.currentPosition.inMilliseconds.toDouble(),
                      min: 0.0,
                      max: this.playerProvider.currentDuration.inMilliseconds.toDouble(),
                      divisions: this.playerProvider.currentDuration.inSeconds,
                      label: Formatter.getTimeFromDouble(
                        this.sliderValue,
                        this.playerProvider.currentDuration,
                      ),
                      onChanged: this.sliderOnChanged,
                      onChangeEnd: this.sliderChangeEnd,
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
                          onPressed: this.playerProvider.hasPrevious() ? this.playerProvider.previous : null,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        this.playerProvider.currentState == AudioPlayerState.PAUSED
                            ? IconButton(
                                iconSize: 40,
                                icon: Icon(Icons.play_arrow),
                                onPressed: this.playerProvider.resume,
                              )
                            : IconButton(
                                iconSize: 40,
                                icon: Icon(Icons.pause),
                                onPressed: this.playerProvider.pause,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        RoundButton(
                          icon: Icons.skip_next,
                          onPressed: this.playerProvider.hasNext() ? this.playerProvider.next : null,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
