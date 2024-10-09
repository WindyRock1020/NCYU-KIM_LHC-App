import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import '../testPage/videoPreview.dart';
import '../widget/appBar.dart';
import '../widget/playPauseOverlay.dart';
import '../widget/progressBar.dart';
import '../testPage/frequency.dart';

class BodyPosturePage extends StatefulWidget {
  final String videoPath;
  final double bodyPosturePoints;
  final double twistLateralInclinationPoints;
  final double distanceOfBodyCenterPoints;
  final double armRaisePoints;
  final double aboveShoulderHeightPoints;
  final double totalAdditonPoints;
  final double totalBodyPoints;
  final String startPosture;
  final String endPosture;

  const BodyPosturePage({
    super.key,
    required this.videoPath,
    this.twistLateralInclinationPoints = 100,
    this.distanceOfBodyCenterPoints = 100,
    this.armRaisePoints = 100,
    this.aboveShoulderHeightPoints = 100,
    this.bodyPosturePoints = 100,
    this.totalBodyPoints = 100,
    this.totalAdditonPoints = 100,
    this.startPosture = "None",
    this.endPosture = "None",
  });

  @override
  _BodyPosturePageState createState() => _BodyPosturePageState();
}

class _BodyPosturePageState extends State<BodyPosturePage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  String? _savedFilePath;
  String twistLateralInclination = "Frequent/constant";
  String distanceOfBodyCenter = "Occasionally";
  String armRaise = "rarely";
  String aboveShoulderHeight = "rarely";

  @override
  void initState() {
    super.initState();
    _saveVideoToLocalDirectory();
  }

  Future<void> _saveVideoToLocalDirectory() async {
    final directory = await getExternalStorageDirectory(); // 獲取外部存儲目錄
    final path = Directory('${directory!.path}/MyVideos');
    if (!await path.exists()) {
      await path.create(recursive: true); // 如果文件夾不存在則創建文件夾
    }

    final newFilePath = '${path.path}/${DateTime.now().toIso8601String()}.mp4';
    final oldFile = File(widget.videoPath);
    await oldFile.copy(newFilePath); // 複製文件到新路徑
    _initializeVideoPlayer(newFilePath);
  }

  void _initializeVideoPlayer(String filePath) async {
    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _savedFilePath = filePath;
            _controller.setLooping(true); // 循環播放
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

  Future<void> _deleteVideo() async {
    if (_savedFilePath != null) {
      final file = File(_savedFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        titleText: "Posture Determination",
        showActionButton: true,
        actionButtonCallback: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPreview(videoPath: widget.videoPath),
            ),
          );
        },
        actionButtonIcon: Icons.video_camera_back_rounded,
      ),
      body: Column(
        children: [
          const LinearProgressIndicator(
            value: 2 / 7,
            valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),
            backgroundColor: Color(0xffd9d9d9),
            minHeight: 5,
          ),
          ProgressBar(
            labelText: "Total body posture: ${widget.bodyPosturePoints + widget.totalAdditonPoints} points",
            current: widget.bodyPosturePoints + widget.totalAdditonPoints,
            textSize: 20,
            max: 26,
            barSize: 40,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 25, left: 40, right: 40),
                    padding: const EdgeInsets.all(20.0),
                    child: const Text(
                      'Video Preview',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_isInitialized)
                    Container(
                      width: 200,
                      margin: const EdgeInsets.all(15),
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
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Text('Initializing...'),
                  if (_savedFilePath != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Video stored at: $_savedFilePath', style: const TextStyle(fontSize: 16)),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 25, left: 40, right: 40),
                    padding: const EdgeInsets.all(20.0),
                    child: const Text(
                      'Worst Posture Changes',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 25,
                        ),
                        child: Image.asset(
                          'assets/image/A2.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 25,
                        ),
                        child: Image.asset(
                          'assets/image/A5.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  ProgressBar(
                    current: widget.bodyPosturePoints,
                    max: 20,
                    barSize: 40,
                    labelText: "Body Posture: ${widget.bodyPosturePoints} points",
                    textSize: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(
                        top: 50, bottom: 25, left: 40, right: 40),
                    padding: const EdgeInsets.all(20.0),
                    child: const Text(
                      'Addition Points',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '$twistLateralInclination\ntwisting and/or lateral inclination',
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/twist.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        ProgressBar(
                          current: widget.twistLateralInclinationPoints,
                          max: 3,
                          barSize: 40,
                          labelText: "${widget.twistLateralInclinationPoints}/3 points",
                          textSize: 20,
                        ),
                        Container(
                          child: Text(
                            'Load centre and/or hands\n$distanceOfBodyCenter\nat a distance from the body',
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/body_center.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        ProgressBar(
                          current: widget.distanceOfBodyCenterPoints,
                          max: 3,
                          barSize: 40,
                          labelText: "${widget.distanceOfBodyCenterPoints}/3 points",
                          textSize: 20,
                        ),
                        Container(
                          child: Text(
                            'Arms $armRaise\nraised hands between\nelbow and shoulder level',
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/arm_raise.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        ProgressBar(
                          current: widget.armRaisePoints,
                          max: 3,
                          barSize: 40,
                          labelText: "${widget.armRaisePoints.toStringAsFixed(0)}/1 points",
                          textSize: 20,
                        ),
                        Container(
                          child: Text(
                            'Hands $aboveShoulderHeight\nabove shoulder height\n${widget.aboveShoulderHeightPoints} points',
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/above_shoulder.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        ProgressBar(
                          current: widget.aboveShoulderHeightPoints,
                          max: 2,
                          barSize: 40,
                          labelText: "${widget.aboveShoulderHeightPoints}/2 points",
                          textSize: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await _deleteVideo();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Re-record",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Frequency(),
                      ),
                    );
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
