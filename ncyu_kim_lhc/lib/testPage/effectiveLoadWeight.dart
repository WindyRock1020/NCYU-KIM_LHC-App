import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ncyu_kim_lhc/widget/optionButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';
import 'videoRecording.dart';

class EffectiveLoadWeight extends StatefulWidget {
  const EffectiveLoadWeight({super.key});

  @override
  State<EffectiveLoadWeight> createState() => _EffectiveLoadWeight();
}

class _EffectiveLoadWeight extends State<EffectiveLoadWeight> {
  final PageController _loadWeightController = PageController();
  String _showgender = "男性";
  String _gender = "male";
  String _weight = "3～5";
  int genderIndex = 0;
  int _loadWeightPoints = 4;
  final List<String> genderTexts = ["男性", "女性"];
  final List<String> weightTexts = ["3～5", "6～10", "11～15", "16～20", "21～25", "26～30", "31～35", "36～40", "> 40"];

  int calculateWeight(String gender, String weight) {
    Map<String, Map<String, int>> weightPoints = {
      "male": {
        "3～5": 4,
        "6～10": 6,
        "11～15": 8,
        "16～20": 11,
        "21～25": 15,
        "26～30": 25,
        "31～35": 35,
        "36～40": 75,
        "> 40": 100,
      },
      "female": {
        "3～5": 6,
        "6～10": 9,
        "11～15": 12,
        "16～20": 25,
        "21～25": 75,
        "26～30": 85,
        "31～35": 100,
        "36～40": 100,
        "> 40": 100,
      },
    };
    return weightPoints[gender]?[weight] ?? 6;
  }

  void _update() {
    setState(() {
      _loadWeightPoints = calculateWeight(_gender, _weight);
      _saveLoadWeightPoints();
    });
  }

  Future<void> _saveLoadWeightPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loadWeightPoints', _loadWeightPoints);
    await prefs.setString('gender', _gender);
    ///print("性別為： $_gender");
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void dispose() {
    _loadWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        titleText: "負重評級",
        showActionButton: false,
        actionButtonCallback: () {},
        actionButtonIcon: Icons.help_rounded,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LinearProgressIndicator(
            value: 1 / 7,
            valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),
            backgroundColor: Color(0xffd9d9d9),
            minHeight: 5,
          ),
          //ProgressBar(current: 1, max: 7,),
          ProgressBar(
            current: calculateWeight(_gender, _weight),
            max: 100,
            barSize: 40,
            labelText:
            "${_loadWeightPoints.toString().replaceAll(".0", "")}分 / 100分",
            textSize: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text(
                            '生理性別',
                            style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            //color: const Color(0xff7392ff),
                          ),
                          width: 200,
                          height: 200,
                          child: PageView(
                            controller: _loadWeightController,
                            children: [
                              Image.asset(
                                "assets/image/$_gender.png",
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        // OptionSlider(
                        //   valueWidth: 0,
                        //   valueHeight: 0,
                        //   options: genderTexts,
                        //   onSelected: (value) {
                        //     setState(() {
                        //       _gender = value;
                        //       _update();
                        //     });
                        //   },
                        // ),
                        OptionButton(
                          initOption: genderTexts[0],
                          options: genderTexts,
                          intervalWidth: 0.03,
                          buttonWidth: 0.4,
                          onSelected: (value) {
                            _showgender = value;
                            if(_showgender == "男性"){
                              _gender ="male";
                            } else{
                              _gender = "female";
                            }
                            _update();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                '實際負重（公斤）',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.symmetric(horizontal: 20),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: const Text(
                                                    "負重評級對照表",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                SingleChildScrollView(
                                                  child: Table(
                                                    border: TableBorder.all(),
                                                    columnWidths: const <int, TableColumnWidth>{
                                                      0: FixedColumnWidth(120.0),
                                                      1: FlexColumnWidth(),
                                                      2: FlexColumnWidth(),
                                                    },
                                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                    children: const [
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('實際負重'))),
                                                          TableCell(child: Center(child: Text('負重評級 (男)'))),
                                                          TableCell(child: Center(child: Text('負重評級 (女)'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('3 - 5 公斤'))),
                                                          TableCell(child: Center(child: Text('4'))),
                                                          TableCell(child: Center(child: Text('6'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 5 - 10 公斤'))),
                                                          TableCell(child: Center(child: Text('6'))),
                                                          TableCell(child: Center(child: Text('9'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 10 - 15 公斤'))),
                                                          TableCell(child: Center(child: Text('8'))),
                                                          TableCell(child: Center(child: Text('12'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 15 - 20 公斤'))),
                                                          TableCell(child: Center(child: Text('11'))),
                                                          TableCell(child: Center(child: Text('25'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 20 - 25 公斤'))),
                                                          TableCell(child: Center(child: Text('15'))),
                                                          TableCell(child: Center(child: Text('75'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 25 - 30 公斤'))),
                                                          TableCell(child: Center(child: Text('25'))),
                                                          TableCell(child: Center(child: Text('85'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 30 - 35 公斤'))),
                                                          TableCell(child: Center(child: Text('35'))),
                                                          TableCell(child: Center(child: Text('100'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 35 - 40 公斤'))),
                                                          TableCell(child: Center(child: Text('75'))),
                                                          TableCell(child: Center(child: Text('100'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('> 40 公斤'))),
                                                          TableCell(child: Center(child: Text('100'))),
                                                          TableCell(child: Center(child: Text('100'))),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                TextButton(
                                                  child: const Text("關閉"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.help_rounded),
                              ),
                            ],
                          ),
                        ),
                        OptionSlider(
                          preIcon: CupertinoIcons.minus_circle,
                          nextIcon: CupertinoIcons.plus_circle,
                          valueHeight: 100,
                          valueWidth: 150,
                          valueFontSize: 25,
                          options: weightTexts,
                          onSelected: (value) {
                            setState(() {
                              _weight = value;
                              // _weightSliderValue = weightTexts.indexOf(value).toDouble();
                              _update();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.9,
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
                      builder: (context) => const VideoRecording()),
                );
              },
              child: const Text(
                "下一步",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: MediaQuery.of(context).size.width*0.4,
          //       height: 60,
          //       margin:
          //       const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          //       child: ElevatedButton(
          //         style: ButtonStyle(
          //           shape: WidgetStatePropertyAll(
          //             RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               side: const BorderSide(color: Colors.transparent),
          //             ),
          //           ),
          //         ),
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         child: const Text(
          //           "上一步",
          //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: MediaQuery.of(context).size.width*0.05),
          //     Container(
          //       width: MediaQuery.of(context).size.width*0.4,
          //       height: 60,
          //       margin:
          //       const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          //       child: ElevatedButton(
          //         style: ButtonStyle(
          //           shape: WidgetStatePropertyAll(
          //             RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               side: const BorderSide(color: Colors.transparent),
          //             ),
          //           ),
          //         ),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const VideoRecording()),
          //           );
          //         },
          //         child: const Text(
          //           "下一步",
          //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
