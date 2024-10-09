import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/appBar.dart';
import '../../widget/optionSlider.dart';
import '../../widget/progressBar.dart';

class LoadHandlingOption extends StatefulWidget {
  final String userName;
  const LoadHandlingOption({super.key, required this.userName});

  @override
  State<LoadHandlingOption> createState() => _LoadHandlingOptionState();
}

class _LoadHandlingOptionState extends State<LoadHandlingOption> {
  String _selectedHandling = "可使用雙手對稱負重";
  int _handlingPoints = 0;
  final List<String> handlingTexts = ["可使用雙手對稱負重", "不對稱負重", "幾乎以單手負重"];

  int calculateHandling(String hands) {
    Map<String, int> handlingPoints = {
      "可使用雙手對稱負重": 0,
      "不對稱負重": 2,
      "幾乎以單手負重": 4
    };
    return handlingPoints[hands] ?? 0;
  }

  void _update() {
    setState(() {
      _handlingPoints = calculateHandling(_selectedHandling);
      _saveHandlingPoints();
    });
  }

  Future<void> _saveHandlingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.userName}_handlingPoints', _handlingPoints);
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        titleText: "負重處理條件",
        showActionButton: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProgressBar(
            labelText: "$_handlingPoints分 / 4分",
            textSize: 20,
            current: _handlingPoints,
            max: 4,
            barSize: 40,
          ),
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 340,
                      height: 150,
                      child: Image.asset(
                        "assets/image/lifting_with_both_hands.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    OptionSlider(
                      options: handlingTexts,
                      valueFontSize: 25,
                      valueWidth: 340,
                      onSelected: (value) {
                        _selectedHandling = value;
                        _update();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: 60,
            margin: const EdgeInsets.symmetric(
                vertical: 15, horizontal: 10),
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
                await _saveHandlingPoints();
                Navigator.pop(context);
              },
              child: const Text(
                "保存修改",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
