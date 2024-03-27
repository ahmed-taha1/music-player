import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/ui/widgets/play_pause_button.dart';
import 'package:music_player/ui/widgets/song_progress.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../services/song_handler.dart';

class PlayerDeck extends StatelessWidget {
  final SongHandler songHandler;
  final Function onTap;
  final bool isLast;

  const PlayerDeck(
      {super.key,
      required this.songHandler,
      required this.onTap,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: songHandler.mediaItem.stream,
      builder: (context, snapshot) {
        MediaItem? playingSong = snapshot.data;
        return playingSong == null
            ? const SizedBox()
            : _buildCard(context, playingSong);
      },
    );
  }

  Card _buildCard(BuildContext context, MediaItem playingSong) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: isLast ? 0 : null,
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          if (!isLast) _buildArtWork(playingSong),
          if (!isLast) _buildArtWorkOverlay(),
          _buildContent(context, playingSong),
        ],
      ),
    );
  }

  Widget _buildArtWorkOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildArtWork(MediaItem playingSong) {
    return Positioned.fill(
      child: QueryArtworkWidget(
        id: int.parse(playingSong.displayDescription!),
        type: ArtworkType.AUDIO,
        size: 1,
        quality: 100,
        artworkHeight: 45,
        artworkWidth: 45,
        artworkBorder: BorderRadius.circular(16),
        nullArtworkWidget: const Icon(Icons.music_note_rounded),
      ),
    );
  }

  Column _buildContent(BuildContext context, MediaItem playingSong) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(context, playingSong),
        _buildProgress(playingSong.duration!),
      ],
    );
  }

  Widget _buildProgress(Duration totalDuration) {
    return ListTile(
      title: isLast
          ? null
          : SongProgress(
              totalDuration: totalDuration,
              songHandler: songHandler,
            ),
    );
  }

  Widget _buildTitle(BuildContext context, MediaItem playingSong) {
    return ListTile(
      onTap: () {
        // Handle tap on the title
        int index = songHandler.queue.value.indexOf(playingSong);
        onTap(index);
      },
      tileColor: isLast ? Colors.transparent : null,
      leading: isLast
          ? null
          : DecoratedBox(
              // Leading widget with a decorated box or artwork
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: isLast
                    ? Colors.transparent
                    : Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.5),
              ),
              child: QueryArtworkWidget(
                // Artwork for the leading box
                id: int.parse(playingSong.displayDescription!),
                type: ArtworkType.AUDIO,
                size: 500,
                quality: 100,
                artworkBorder: BorderRadius.circular(8.0),
                errorBuilder: (p0, p1, p2) =>
                    const Icon(Icons.music_note_rounded),
              ),
            ),
      title: Text(
        isLast ? "" : playingSong.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: playingSong.artist == null
          ? null
          : Text(
              isLast ? "" : playingSong.artist!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: isLast
          ? null
          : SizedBox(
              // Trailing widget with song progress and play/pause button
              height: 50,
              width: 50,
              child: _buildTrailingWidget(context, playingSong),
            ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context, MediaItem playingSong) {
    return Stack(
      children: [
        StreamBuilder<Duration>(
          stream: AudioService.position,
          builder: (context, durationSnapshot) {
            if (durationSnapshot.hasData) {
              // Calculate and display song progress
              double progress = durationSnapshot.data!.inMilliseconds /
                  playingSong.duration!.inMilliseconds;
              return Center(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3,
                  backgroundColor: isLast
                      ? Colors.transparent
                      : Theme.of(context).hoverColor,
                  value: progress,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Center(
          // Play/Pause button
          child: PlayPauseButton(
            size: 30,
            songHandler: songHandler,
          ),
        ),
      ],
    );
  }
}
