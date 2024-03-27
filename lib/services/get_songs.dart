import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/request_songs_permission.dart';
import 'package:music_player/services/song_model_to_media_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<List<MediaItem>> getSongs() async {
  try{
    await requestSongsPermission();
    final List<MediaItem> songs = [];

    final OnAudioQuery onAudioQuery = OnAudioQuery();

    final List<SongModel> songModels = await onAudioQuery.querySongs();

    for (final SongModel songModel in songModels){
      final MediaItem song = await songModelToMediaItem(songModel);
      songs.add(song);
    }
    return songs;
  } catch(e){
    debugPrint('Error getting songs: $e');
    return [];
  }
}