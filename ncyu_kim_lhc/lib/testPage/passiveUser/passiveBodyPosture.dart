import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/testPage/passiveUser/passiveResult.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../testPage/videoPreview.dart';
import '../../widget/appBar.dart';
import '../../widget/playPauseOverlay.dart';
import '../../widget/progressBar.dart';

class PassiveBodyPosture extends StatefulWidget {
  final String userName;
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

  const PassiveBodyPosture({
    super.key,
    required this.userName,
    required this.videoPath,
    this.twistLateralInclinationPoints = 1.0,
    this.distanceOfBodyCenterPoints = 1.0,
    this.armRaisePoints = 1.0,
    this.aboveShoulderHeightPoints = 1.0,
    this.bodyPosturePoints = 30,
    this.totalBodyPoints = 30,
    this.totalAdditonPoints = 30,
    this.startPosture = "1",
    this.endPosture = "1",
  });

  @override
  _PassiveBodyPostureState createState() => _PassiveBodyPostureState();
}

class _PassiveBodyPostureState extends State<PassiveBodyPosture> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  String twistLateralInclination = "初始化中";
  String distanceOfBodyCenter = "初始化中";
  String armRaise = "初始化中";
  String aboveShoulderHeight = "初始化中";
  String startPos = "None";
  String endPos = "None";

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.videoPath);
    _setPointsText();
    startPos = widget.startPosture;
    endPos = widget.endPosture;
    _saveBodyPoints();
  }

  void _setPointsText() {
    setState(() {
      twistLateralInclination =
          _getTwistLateralInclinationText(widget.twistLateralInclinationPoints);
      distanceOfBodyCenter =
          _getDistanceOfBodyCenterText(widget.distanceOfBodyCenterPoints);
      armRaise = _getArmRaiseText(widget.armRaisePoints);
      aboveShoulderHeight =
          _getAboveShoulderHeightText(widget.aboveShoulderHeightPoints);
    });
  }

  String _getTwistLateralInclinationText(double points) {
    if (points == 0) return "從不";
    if (points == 1) return "偶爾";
    if (points == 3) return "經常";
    return "未獲得數據";
  }

  String _getDistanceOfBodyCenterText(double points) {
    if (points == 0) return "從未";
    if (points == 1) return "偶爾";
    if (points == 3) return "經常";
    return "未獲得數據";
  }

  String _getArmRaiseText(double points) {
    if (points == 0) return "不";
    if (points == 0.5) return "偶爾";
    if (points == 1) return "經常";
    return "未獲得數據";
  }

  String _getAboveShoulderHeightText(double points) {
    if (points == 0) return "不";
    if (points == 1) return "偶爾";
    if (points == 2) return "經常";
    return "未獲得數據";
  }

  void _initializeVideoPlayer(String filePath) {
    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
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
    final file = File(widget.videoPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> _saveBodyPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('現在${widget.totalBodyPoints}');
    await prefs.setDouble('${widget.userName}_totalBodyPosturePoints', widget.totalBodyPoints);
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
        titleText: "身體姿勢",
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
      body:
      Column(
        children: [
          const LinearProgressIndicator(
            value: 2 / 7,
            valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),
            backgroundColor: Color(0xffd9d9d9),
            minHeight: 5,
          ),
          ProgressBar(
            labelText:
            "身體姿勢總分: ${widget.totalBodyPoints.toString().replaceAll('.0', '')} 分",
            current: widget.totalBodyPoints,
            textSize: 20,
            max: 26,
            barSize: 40,
          ),
          Expanded(
            child: SingleChildScrollView(
              child:
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            '影片預覽',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
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
                          const Text('正在準備中...'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            '姿勢變化',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.only(top: 20, bottom: 25),
                              child: Image.asset(
                                'assets/image/A$startPos.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.only(top: 20, bottom: 25),
                              child: Image.asset(
                                'assets/image/A$endPos.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        ProgressBar(
                          current: widget.bodyPosturePoints,
                          max: 20,
                          barSize: 40,
                          labelText:
                          "身體姿勢: ${widget.bodyPosturePoints.toString().replaceAll('.0', '')} 分",
                          textSize: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          child: const Text(
                            '額外分數',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
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
                                width: 340,
                                height: 150,
                                child: Image.asset(
                                  "assets/image/twist.png",
                                  fit: BoxFit.contain,
                                ),
                              ),Container(
                                child: Text(
                                  '軀幹$twistLateralInclination扭轉、側傾',
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ProgressBar(
                                current: widget.twistLateralInclinationPoints,
                                max: 3,
                                barSize: 40,
                                labelText:
                                "${widget.twistLateralInclinationPoints.toString().replaceAll(".0", "")}/3 分",
                                textSize: 20,
                              ),
                              const SizedBox(height: 30,),
                              Container(
                                width: 340,
                                height: 150,
                                child: Image.asset(
                                  "assets/image/body_center.png",
                                  fit: BoxFit.contain,
                                ),
                              ),Container(
                                child: Text(
                                  "重心$distanceOfBodyCenter遠離身體",
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ProgressBar(
                                current: widget.distanceOfBodyCenterPoints,
                                max: 3,
                                barSize: 40,
                                labelText:
                                "${widget.distanceOfBodyCenterPoints.toString().replaceAll(".0", "")}/3 分",
                                textSize: 20,
                              ),
                              const SizedBox(height: 30,),

                              Container(
                                width: 340,
                                height: 150,
                                child: Image.asset(
                                  "assets/image/arm_raise.png",
                                  fit: BoxFit.contain,
                                ),
                              ),Container(
                                child: Text(
                                  "手臂$armRaise需抬舉",
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ProgressBar(
                                current: widget.armRaisePoints,
                                max: 1,
                                barSize: 40,
                                labelText:
                                "${widget.armRaisePoints.toString().replaceAll(".0", "")}/1 分",
                                textSize: 20,
                              ),
                              const SizedBox(height: 30,),
                              Container(
                                width: 340,
                                height: 150,
                                child: Image.asset(
                                  "assets/image/above_shoulder.png",
                                  fit: BoxFit.contain,
                                ),
                              ),Container(
                                child: Text(
                                  "手$aboveShoulderHeight會高過肩膀",
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ProgressBar(
                                current: widget.aboveShoulderHeightPoints,
                                max: 2,
                                barSize: 40,
                                labelText:
                                "${widget.aboveShoulderHeightPoints.toString().replaceAll(".0", "")}/2 分",
                                textSize: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.4,
                height: 60,
                margin:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await _deleteVideo();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "重新錄製",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.05),
              Container(
                width: MediaQuery.of(context).size.width*0.4,
                height: 60,
                margin:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassiveResult(userName: widget.userName),
                      ),
                    );
                  },
                  child: const Text(
                    "下一步",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
