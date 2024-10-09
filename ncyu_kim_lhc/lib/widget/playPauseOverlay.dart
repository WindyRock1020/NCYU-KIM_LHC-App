import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayPauseOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  const PlayPauseOverlay({super.key, required this.controller});

  @override
  _PlayPauseOverlayState createState() => _PlayPauseOverlayState();
}

class _PlayPauseOverlayState extends State<PlayPauseOverlay> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (!mounted) return;
      final isControllerPlaying = widget.controller.value.isPlaying;
      if (isControllerPlaying != isPlaying) {
        setState(() {
          isPlaying = isControllerPlaying;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
        } else {
          widget.controller.play();
        }
        setState(() {
          isPlaying = widget.controller.value.isPlaying;
        });
      },
      child: Center(
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 75.0,
        ),
      ),
    );
  }
}