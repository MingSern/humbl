import 'package:flutter/material.dart';
import 'package:humbl/components/player.dart';
import 'package:humbl/helpers/palette.dart';
import 'package:humbl/keys/root_key.dart';
import 'package:humbl/providers/navigation_provider.dart';
import 'package:humbl/providers/player_provider.dart';
import 'package:humbl/screens/music/music_screen.dart';
import 'package:humbl/screens/profile/profile_screen.dart';
import 'package:humbl/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

class Index extends StatelessWidget {
  final List<Screen> screens = [
    Screen(MusicScreen(), Icons.music_note, "Music"),
    Screen(SearchScreen(), Icons.search, "Search"),
    Screen(ProfileScreen(), Icons.person, "Profile"),
  ];

  final NavigationProvider navigationProvider = Provider.of<NavigationProvider>(rootKey.currentContext);
  final PlayerProvider playerProvider = Provider.of<PlayerProvider>(rootKey.currentContext);

  void viewSongDetail(BuildContext context) {
    Navigator.pushNamed(context, "/songDetail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          IndexedStack(
            index: this.navigationProvider.index,
            children: this.screens.map((screen) {
              return screen.widget;
            }).toList(),
          ),
          Player(
            provider: this.playerProvider,
            onTap: () => this.viewSongDetail(context),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Palette.sesame,
        unselectedItemColor: Colors.grey,
        currentIndex: this.navigationProvider.index,
        onTap: this.navigationProvider.setIndex,
        items: this.screens.map((screen) {
          return BottomNavigationBarItem(
            icon: Icon(screen.iconData),
            title: Text(screen.title),
          );
        }).toList(),
      ),
    );
  }
}

class Screen {
  Widget widget;
  IconData iconData;
  String title;

  Screen(this.widget, this.iconData, this.title) {
    this.widget = widget;
    this.iconData = iconData;
    this.title = title;
  }
}
