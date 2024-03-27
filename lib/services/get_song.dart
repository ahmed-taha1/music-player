import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<Uri?> getSongArt({
  required int id,
  required ArtworkType type,
  required int qauality,
  required int size,
}) async {
  try {
    final OnAudioQuery onAudioQuery = OnAudioQuery();

    final Uint8List? data = await onAudioQuery.queryArtwork(
      id,
      type,
      quality: qauality,
      size: size,
    );

    Uri? art;
    if(data != null){
      final Directory tempDir = Directory.systemTemp;

      final File file = File('${tempDir.path}/$id.jpg');

      await file.writeAsBytes(data);

      art = file.uri;
    }

    return art;
  } catch (e) {
    debugPrint('Error getting song art: $e');
    return null;
  }
}
