import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/song_handler.dart';

class PlayPauseButton extends StatelessWidget {
  final SongHandler songHandler;
  final double size;

  const PlayPauseButton(
      {super.key, required this.songHandler, required this.size});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: songHandler.playbackState.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool playing = snapshot.data!.playing;
          return IconButton(
            icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: size),
            onPressed: () {
              if(playing) {
                songHandler.pause();
              } else {
                songHandler.play();
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
