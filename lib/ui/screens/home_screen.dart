import 'package:flutter/material.dart';

import '../../services/song_handler.dart';

class HomeScreen extends StatefulWidget {
  final SongHandler songHandler;
  const HomeScreen({super.key, required this.songHandler});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
