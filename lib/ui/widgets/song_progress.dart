import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/song_handler.dart';

class SongProgress extends StatelessWidget {
  final Duration totalDuration;
  final SongHandler songHandler;

  const SongProgress(
      {super.key, required this.totalDuration, required this.songHandler});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, snapshot) {
        Duration? position = snapshot.data;
        return ProgressBar(
          progress: position ?? Duration.zero,
          total: totalDuration,
          onSeek: (value) {
            songHandler.seek(value);
          },
          barHeight: 5,
          thumbRadius: 2.5,
          thumbGlowRadius: 5,
          timeLabelLocation: TimeLabelLocation.below,
          timeLabelPadding: 8.0,
        );
      },
    );
  }
}
