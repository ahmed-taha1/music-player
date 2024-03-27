import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/ui/widgets/songs_list.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../notifiers/song_provider.dart';
import '../../services/song_handler.dart';
import '../widgets/player_deck.dart';

class HomeScreen extends StatefulWidget {
  final SongHandler songHandler;

  const HomeScreen({super.key, required this.songHandler});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AutoScrollController _autoScrollController = AutoScrollController();

  void _scrollTo(int index) {
    _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle,
        duration: const Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      child: Consumer<SongProvider>(
        builder: (context, ref, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Music Player'),
            ),
            body: ref.isLoading
                ? _buildLoadingIndicator()
                : _buildSongsList(
                    songHandler: widget.songHandler,
                    songs: ref.songs,
                    autoScrollController: _autoScrollController,
                  ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildSongsList({
    required SongHandler songHandler,
    required List<MediaItem> songs,
    required AutoScrollController autoScrollController,
  }) {
    return Stack(
      children: [
        SongsList(
          songs,
          songHandler,
          autoScrollController,
        ),
        _buildPlayerDeck(),
      ],
    );
  }

  Column _buildPlayerDeck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PlayerDeck(
          songHandler: widget.songHandler,
          onTap: _scrollTo,
          isLast: false,
        ),
      ],
    );
  }
}
