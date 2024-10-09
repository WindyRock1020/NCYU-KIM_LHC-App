import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';

class FreqOption extends StatefulWidget {
  final String userName;
  const FreqOption({super.key, required this.userName});
  @override
  State<FreqOption> createState() => _FreqOption();
}

class _FreqOption extends State<FreqOption> {
  double _frequencySliderValue = 0.0;
  double _freqPoints = 1;
  String _selectedFreqText = "5";
  final List<String> freqTexts = ["5", "20", "50", "100", "150", "220", "300", "500", "750", "1000", "1500", "2000", "2500"];
  double calculateFreq(String freq) {
    Map<String, double> freqPoints = {
      "5": 1, "20": 1.5, "50": 2, "100": 2.5, "150": 3, "220": 3.5, "300": 4, "500": 5, "750": 6, "1000": 7, "1500": 8, "2000": 9, "2500": 10
    };
    return freqPoints[freq] ?? 1;
  }
  void _update() {
    setState(() {
      _freqPoints = calculateFreq(_selectedFreqText);
    });
  }
  Future<void> _saveFreqPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${widget.userName}_frequencyPoints', _freqPoints);
  }

  @override
  void initState() {
    super.initState();
    _update();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        titleText: "時間評級",
        showActionButton: false,
        actionButtonCallback: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Container(),
                content: Image.asset(
                  "assets/image/gender_weight_list.png",
                  width: 500,
                ),
              );
            },
          );
        },
        actionButtonIcon: Icons.help_rounded,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("菜單瀏覽",textAlign: TextAlign.center),
          LinearProgressIndicator(value: 3 / 7, valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)), backgroundColor: Color(0xffd9d9d9), minHeight: 5,),
          ProgressBar(
            current: calculateFreq(freqTexts[_frequencySliderValue.toInt()]),
            max: 10,
            labelText: "Frequency: ${calculateFreq(freqTexts[_frequencySliderValue.toInt()]).toString().replaceAll(".0", "").padLeft(3, ' ')} points",
            textSize: 20,
            barSize: 40,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Frequency',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Color(0xffffffff),
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30)),
                                ),
                                isDismissible: true,
                                enableDrag: true,
                                builder: (context) => Container(
                                    height: 550,
                                    width: MediaQuery.of(context).size.width * 1,
                                    child: Column(
                                      children: [
                                        Text('Frequency', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
                                        SizedBox(height: 30,),
                                        Text('times per sub-activity and working day', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                                        SizedBox(height: 5,),
                                        ///Image.asset("assets/image/timePoints.png")
                                      ],
                                    )
                                ),
                              );
                            },
                            icon: Icon(Icons.help_rounded)),
                      ],
                    ),
                  ),
                ),
                OptionSlider(
                  preIcon: CupertinoIcons.minus_circle,
                  nextIcon: CupertinoIcons.plus_circle,
                  valueHeight: 100,
                  valueWidth: 200,
                  valueFontSize: 25,
                  options: freqTexts,
                  onSelected: (value) {
                    setState(() {
                      _selectedFreqText = value;
                      _frequencySliderValue = freqTexts.indexOf(value).toDouble();
                      _update();
                      //print(value);
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                    //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Colors.transparent)))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                width: 150,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                    //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Colors.transparent)))),
                  onPressed: () async {
                    await _saveFreqPoints();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
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
