import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/services/song_handler.dart';
import 'package:music_player/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'notifiers/song_provider.dart';

SongHandler _songHandler = SongHandler();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  _songHandler = await AudioService.init(
    builder: ()=> SongHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.dum.app',
      androidNotificationChannelName: 'Dum Player',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    )
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=> SongProvider()..loadSongs(_songHandler)),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: 'Music Player',
      // theme: ThemeData(
      //   colorScheme: const ColorScheme.light(),
      //   useMaterial3: true,
      // ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      // Set HomeScreen as the initial screen with the provided SongHandler
      home: HomeScreen(songHandler: _songHandler),
    );
  }
}
