import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../widget/playPauseOverlay.dart';

class VideoPreview extends StatefulWidget {
  final String videoPath;

  const VideoPreview({super.key, required this.videoPath});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.videoPath);
  }

  void _initializeVideoPlayer(String filePath) async {
    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.play();
          });
        }
      }).catchError((error) {
        print('Error initializing video player: $error');
        if (mounted) {
          setState(() => _isInitialized = false);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('影片預覽'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isInitialized
                ? Center(
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_controller),
                            PlayPauseOverlay(controller: _controller),
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            )
                          ],
                        )),
                  )
                : const Text('Initializing...'),
          ),
        ],
      ),
    );
  }
}
