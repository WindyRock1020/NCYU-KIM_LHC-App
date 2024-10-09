import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncyu_kim_lhc/widget/appBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'loading.dart';

class VideoSelection {
  Future<void> pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(videoPath: video.path),
        ),
      );
    }
  }
}

class VideoRecording extends StatefulWidget {
  const VideoRecording({super.key});

  @override
  VideoRecordingState createState() => VideoRecordingState();
}

class VideoRecordingState extends State<VideoRecording> {
  late CameraController _controller;
  bool _isRecording = false;
  final VideoSelection _videoSelector = VideoSelection();
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    await requestPermissions();
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }

  Future<void> toggleRecording() async {
    if (_isRecording) {
      final file = await _controller.stopVideoRecording();
      final String directory = (await getApplicationDocumentsDirectory()).path;
      final String videoPath = '$directory/${DateTime.now().toIso8601String()}.mp4';
      await file.saveTo(videoPath);
      await Gal.putVideo(videoPath, album: "KIM_LHC_VID");
      setState(() {
        _isRecording = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(videoPath: videoPath),
        ),
      );
    } else {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        titleText: "Posture Recording",
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CameraPreview(_controller),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ElevatedButton.icon(
                        icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
                        label: Text(_isRecording ? "Stop" : "Start", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                        onPressed: toggleRecording,
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: 150,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.file_upload),
                        label: const Text("Import", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                        onPressed: () => _videoSelector.pickVideo(context),
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
