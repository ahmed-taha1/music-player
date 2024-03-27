import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';

import '../services/get_songs.dart';
import '../services/song_handler.dart';

class SongProvider extends ChangeNotifier{
  List<MediaItem> _songs = [];

  List<MediaItem> get songs => _songs;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> loadSongs(SongHandler songHandler) async{
    _songs = await getSongs();

    await songHandler.initSongs(_songs);
    _isLoading = false;
    notifyListeners();
  }
}