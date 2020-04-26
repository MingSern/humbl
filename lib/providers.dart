import 'package:humbl/providers/music_provider.dart';
import 'package:humbl/providers/navigation_provider.dart';
import 'package:humbl/providers/player_provider.dart';
import 'package:humbl/providers/theme_provider.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<NavigationProvider>(
    create: (_) => NavigationProvider(),
  ),
  ChangeNotifierProvider<ThemeProvider>(
    create: (_) => ThemeProvider(),
  ),
  ChangeNotifierProvider<MusicProvider>(
    create: (_) => MusicProvider(),
  ),
  ChangeNotifierProxyProvider<MusicProvider, PlayerProvider>(
    create: (_) => PlayerProvider(),
    update: (_, music, player) => player..update(music.songs),
  ),
];
