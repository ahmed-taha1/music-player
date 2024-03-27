import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/get_song.dart';
import 'package:music_player/utils/formatted_titile.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<MediaItem> songModelToMediaItem(SongModel song) async {
  try {
    final Uri? art = await getSongArt(
        id: song.id, type: ArtworkType.AUDIO, qauality: 100, size: 300);

    return MediaItem(
      id: song.uri.toString(),
      artUri: art,
      artist: song.artist,
      duration: Duration(milliseconds: song.duration!),
      displayDescription: song.id.toString(),
      title: formattedTitle(song.title).trim(),
    );
  } catch (e) {
    debugPrint('Error converting SongModel to MediaItem: $e');
    return const MediaItem(id: '', title: '');
  }
}
