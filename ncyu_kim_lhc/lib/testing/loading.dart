import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ncyu_kim_lhc/widget/appBar.dart';
import 'dart:convert';
import 'bodyTest.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatefulWidget {
  final String videoPath;

  const LoadingPage({super.key, required this.videoPath});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _uploadVideo();
  }

  Future<void> _uploadVideo() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://lilchillboi.asuscomm.com:5000'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', widget.videoPath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);

      if (result['checkPersonInScreen'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrorPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BodyPosturePage(
              twistLateralInclinationPoints: (result['twist'] ?? 0).toDouble(),
              distanceOfBodyCenterPoints: (result['distance of body'] ?? 0).toDouble(),
              armRaisePoints: (result['arm raise'] ?? 0).toDouble(),
              aboveShoulderHeightPoints: (result['above shoulder'] ?? 0).toDouble(),
              bodyPosturePoints: (result['BodyPosturePoint'] ?? 0).toDouble(),
              totalBodyPoints: (result['total_score'] ?? 0).toDouble(),
              totalAdditonPoints:(result['Addition Point']?? 0).toDouble(),
              videoPath: widget.videoPath,
              startPosture:(result['start'] ?? "None").toString(),
              endPosture:(result['end']?? "None").toString(),
            ),
          ),
        );
      }
    } else {
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "正在判定，請稍後",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 75,),
            LoadingAnimationWidget.waveDots(
                color: const Color(0xff7392ff),
                size: 100
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        titleText: "Error",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "视频处理失败，请重新上传。",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("返回"),
            ),
          ],
        ),
      ),
    );
  }
}
