import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/ui/widgets/song_item.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../services/song_handler.dart';

class SongsList extends StatelessWidget {
  final List<MediaItem> songs;
  final SongHandler songHandler;
  final AutoScrollController autoScrollController;

  const SongsList(this.songs, this.songHandler, this.autoScrollController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return songs.isEmpty
        ? const Center(
            child: Text('No songs found'),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: autoScrollController,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final MediaItem song = songs[index];
              return StreamBuilder(
                stream: songHandler.mediaItem.stream,
                builder: (context, snapshot) {
                  MediaItem? playingSong = snapshot.data;
                  return index == (songs.length - 1)
                      ? _buildLastSongItem(song, playingSong)
                      : AutoScrollTag(
                          key: ValueKey(index),
                          controller: autoScrollController,
                          index: index,
                          child: _buildRegularSongItem(song, playingSong),
                        );
                },
              );
            },
          );
  }

  Widget _buildLastSongItem(MediaItem song, MediaItem? playingSong) {
    return Column(
      children: [
        SongItem(
          isPlaying: song == playingSong,
          id: int.parse(song.displayDescription!),
          onSongTap: () async {
            await songHandler.skipToQueueItem(songs.length - 1);
          },
          artist: song.artist,
          title: song.title,
          art: song.artUri,
        ),
      ],
    );
  }

  Widget _buildRegularSongItem(MediaItem song, MediaItem? playingSong) {
    return SongItem(
      isPlaying: song == playingSong,
      id: int.parse(song.displayDescription!),
      onSongTap: () async {
        await songHandler.skipToQueueItem(songs.indexOf(song));

      },
      artist: song.artist,
      title: song.title,
      art: song.artUri,
    );
  }
}
