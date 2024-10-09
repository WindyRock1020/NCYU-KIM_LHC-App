import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ncyu_kim_lhc/widget/appBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  Future<void>? _initializeControllerFuture; // 移除 late，改為 Future<void>?
  late List<CameraDescription> cameras;
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[selectedCameraIdx], ResolutionPreset.high, enableAudio: false);
        _initializeControllerFuture = _controller.initialize(); // 在此初始化 Future
        await _initializeControllerFuture;
        if (mounted) {
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(
          msg: "無可用的相機",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "初始化相機失敗: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      _initializeControllerFuture = initCamera(); // 在這裡初始化相機
    } else {
      Fluttertoast.showToast(
        msg: "請允許相機權限",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
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

  void onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx == 1 ? 0 : 1;
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture, // 使用初始化的 Future
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                  child: const Text(
                    "拍攝角度建議為側面\n人體請全程入鏡",
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: CameraPreview(_controller),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height*0.1,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.photo_library, size: 40, color: Colors.white),
                      onPressed: () => _videoSelector.pickVideo(context),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height*0.1,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.arrow_2_circlepath, size: 40, color: Colors.white),
                      onPressed: onSwitchCamera,
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height*0.1,
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
