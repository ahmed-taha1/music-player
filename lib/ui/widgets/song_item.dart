import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/services/uri_to_file.dart';
import 'package:music_player/utils/formatted_text.dart';
import 'package:transparent_image/transparent_image.dart';

class SongItem extends StatelessWidget {
  final String? searchedWord;
  final bool isPlaying;
  final Uri? art;
  final String? title;
  final String? artist;
  final int id;
  final VoidCallback onSongTap;

  const SongItem(
      {super.key,
      this.searchedWord,
      required this.isPlaying,
      this.art,
      this.title,
      this.artist,
      required this.id,
      required this.onSongTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        tileColor: isPlaying
            ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
            : null,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        onTap: onSongTap,
        leading: _buildLeading(),
        title: _buildTitle(context),
        subtitle: _buildSubtitle(context),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return searchedWord != null
        ? formattedText(
            corpus: title!, searchedWord: searchedWord!, context: context)
        : Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
  }

  Text? _buildSubtitle(BuildContext context){
    return artist != null
        ? searchedWord != null
            ? formattedText(
                corpus: artist!, searchedWord: searchedWord!, context: context)
            : Text(
                artist!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
        : null;
  }
  Widget _buildLeading() {
    return FutureBuilder<File?>(
      future: uriToFile(art),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.music_note);
        }
        return Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          ),
          child: snapshot.data == null
              ? const Icon(Icons.music_note)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: FileImage(snapshot.data!),
                    fadeInDuration: const Duration(milliseconds: 700),
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }
}
