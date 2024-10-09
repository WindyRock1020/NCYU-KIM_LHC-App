import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'passiveBodyPosture.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PassiveLoading extends StatefulWidget {
  final String videoPath;
  final String userName;

  const PassiveLoading({super.key, required this.videoPath,required this.userName});

  @override
  _PassiveLoadingState createState() => _PassiveLoadingState();
}

class _PassiveLoadingState extends State<PassiveLoading> {
  late String _uploadURL;
  @override
  void initState() {
    super.initState();
    _loadCustomUrl().then((_)=>_uploadVideo());
  }

  Future<void> _loadCustomUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uploadURL = prefs.getString('uploadUrl') ?? 'http://192.168.100.10:5001';
  }

  Future<void> _uploadVideo() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_uploadURL/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', widget.videoPath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      if(result["total_score"] != null){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PassiveBodyPosture(
              userName: widget.userName,
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
      }else{
        Fluttertoast.showToast(
          msg: "獲取數據失敗\n請重新錄製",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: const Color(0xff7392ff),
          fontSize: 20.0,
        );
        Navigator.pop(context);
      }
    } else {
      ///print('獲取數據失敗');
      Fluttertoast.showToast(
        msg: "獲取數據失敗\n請重新錄製",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: const Color(0xff7392ff),
        fontSize: 20.0,
      );
      Navigator.pop(context);
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
