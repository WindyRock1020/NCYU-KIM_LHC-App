import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/appBar.dart';
import '../../widget/optionSlider.dart';
import '../../widget/progressBar.dart';

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
  final List<String> freqTexts = [
    "5", "20", "50", "100", "150", "220", "300", "500", "750", "1000", "1500", "2000", "2500"
  ];

  double calculateFreq(String freq) {
    Map<String, double> freqPoints = {
      "5": 1, "20": 1.5, "50": 2, "100": 2.5, "150": 3, "220": 3.5, "300": 4, "500": 5,
      "750": 6, "1000": 7, "1500": 8, "2000": 9, "2500": 10
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              current: calculateFreq(freqTexts[_frequencySliderValue.toInt()]),
              max: 10,
              labelText: "${calculateFreq(freqTexts[_frequencySliderValue.toInt()]).toString().replaceAll(".0", "").padLeft(3, ' ')}分 / 10分",
              textSize: 20,
              barSize: 40,
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              '動作頻率',
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
                                                    "分數對照表",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "每天從事本項作業的頻率(次數)",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                SingleChildScrollView(
                                                  child: Table(
                                                    border: TableBorder.all(),
                                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                    children: const [
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('動作頻率'))),
                                                          TableCell(child: Center(child: Text('分數'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('5'))),
                                                          TableCell(child: Center(child: Text('1.5'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('20'))),
                                                          TableCell(child: Center(child: Text('2'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('50'))),
                                                          TableCell(child: Center(child: Text('2'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('100'))),
                                                          TableCell(child: Center(child: Text('2.5'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('150'))),
                                                          TableCell(child: Center(child: Text('3'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('220'))),
                                                          TableCell(child: Center(child: Text('3.5'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('300'))),
                                                          TableCell(child: Center(child: Text('4'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('500'))),
                                                          TableCell(child: Center(child: Text('5'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('750'))),
                                                          TableCell(child: Center(child: Text('6'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('1000'))),
                                                          TableCell(child: Center(child: Text('7'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('1500'))),
                                                          TableCell(child: Center(child: Text('8'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('2000'))),
                                                          TableCell(child: Center(child: Text('9'))),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(child: Center(child: Text('2500'))),
                                                          TableCell(child: Center(child: Text('10'))),
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
                                icon: const Icon(Icons.help_rounded)),
                          ],
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
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                  await _saveFreqPoints();
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
      ),
    );
  }
}
