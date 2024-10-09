import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ncyu_kim_lhc/widget/appBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'passiveLoading.dart';

class VideoSelection {
  Future<void> pickVideo(BuildContext context, String userName) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassiveLoading(videoPath: video.path, userName: userName),
        ),
      );
    }
  }
}

class PassiveRecording extends StatefulWidget {
  final String userName;
  const PassiveRecording({super.key, required this.userName});

  @override
  PassiveRecordingState createState() => PassiveRecordingState();
}

class PassiveRecordingState extends State<PassiveRecording> {
  late CameraController _controller;
  bool _isRecording = false;
  final VideoSelection _videoSelector = VideoSelection();
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _initializeControllerFuture = initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[selectedCameraIdx], ResolutionPreset.high, enableAudio: false);
      try {
        await _controller.initialize();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print('No cameras available');
    }
  }

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.microphone, Permission.storage].request();
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
          builder: (context) => PassiveLoading(videoPath: videoPath, userName: widget.userName),
        ),
      );
    } else {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  void onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx == 1 ? 0 : 1;
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        Color backgroundColor = snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized
            ? const Color(0xffffff)
            : Colors.white;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: const SharedAppBar(
            titleText: "姿勢拍攝",
          ),
          body: snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized
              ? Column(
                children: [
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                          child: Text("拍攝角度建議為側面\n人體請全程入鏡",style:TextStyle(fontSize: 20,color: Colors.white70),textAlign: TextAlign.center,))),
                  Stack(
                    children: [
                  CameraPreview(_controller),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.photo_library, size: 40, color: Colors.white),
                      onPressed: () => _videoSelector.pickVideo(context, widget.userName),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.arrow_2_circlepath, size: 40, color: Colors.white),
                      onPressed: onSwitchCamera,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: toggleRecording,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _isRecording ? Colors.red : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isRecording ? Icons.stop : Icons.videocam,
                            color: _isRecording ? Colors.white : Colors.red,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                              ],
                            ),
                ],
              )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "鏡頭準備中...",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                LoadingAnimationWidget.waveDots(
                  color: const Color(0xff7392ff),
                  size: 100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
