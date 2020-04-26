import 'dart:io';
import 'package:flutter/material.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers/music_provider.dart';
import 'package:humbl/providers/player_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final MusicProvider musicProvider = Provider.of<MusicProvider>(rootKey.currentContext);
  final PlayerProvider playerProvider = Provider.of<PlayerProvider>(rootKey.currentContext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView.separated(
        itemCount: this.musicProvider.songs?.length ?? 0,
        itemBuilder: (context, index) {
          var song = this.musicProvider.songs[index];
          bool isLastIndex = this.musicProvider.songs.length - 1 == index;

          return Column(
            children: <Widget>[
              ListTile(
                leading: song.albumArtwork != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(File(song.albumArtwork)),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.music_note),
                      ),
                title: Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                ),
                selected: song == this.playerProvider.selectedSong,
                onTap: () => this.playerProvider.open(song),
              ),
              isLastIndex ? Container(height: 70) : Container()
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
          );
        },
      ),
    );
  }
}
