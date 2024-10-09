import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/appBar.dart';
import '../../widget/optionButton.dart';
import '../../widget/optionSlider.dart';
import '../../widget/progressBar.dart';

class UnfavorOption extends StatefulWidget {
  final String userName;

  const UnfavorOption({super.key, required this.userName});

  @override
  State<UnfavorOption> createState() => _UnfavorableWorkingConditions();
}

class _UnfavorableWorkingConditions extends State<UnfavorOption> {
  String _joint = "幾乎不";
  String _forceTransfer = "不太";
  String _unfavorableWeatherConditions = "無";
  String _spatialConditions = "正常";
  String _clothes = "無";
  String _difficultiesHolding = "無";
  int _unfavorablePoints = 0;

  List<String> u1Texts = ["幾乎不", "偶爾", "頻繁"];
  List<String> u2Texts = ["不太", "稍微", "非常"];
  List<String> u3Texts = ["無", "有"];
  List<String> u4Texts = ["正常", "受限", "不良"];
  List<String> u5Texts = ["無", "有"];
  List<String> u6Texts = ["正常", "困難", "艱難"];

  Map<String, int> u1Points = {"幾乎不": 0, "偶爾": 1, "頻繁": 2};
  Map<String, int> u2Points = {"不太": 0, "稍微": 1, "非常": 2};
  Map<String, int> u3Points = {"無": 0, "有": 1};
  Map<String, int> u4Points = {"正常": 0, "受限": 1, "不良": 2};
  Map<String, int> u5Points = {"無": 0, "有": 1};
  Map<String, int> u6Points = {"正常": 0, "困難": 2, "艱難": 5};

  int calculateUnfavorable(
      String u1, String u2, String u3, String u4, String u5, String u6) {
    int uPoints = 0;
    uPoints += u1Points[u1] ?? 0;
    uPoints += u2Points[u2] ?? 0;
    uPoints += u3Points[u3] ?? 0;
    uPoints += u4Points[u4] ?? 0;
    uPoints += u5Points[u5] ?? 0;
    uPoints += u6Points[u6] ?? 0;
    return uPoints;
  }

  void _update() {
    setState(() {
      _unfavorablePoints = calculateUnfavorable(
          _joint,
          _forceTransfer,
          _unfavorableWeatherConditions,
          _spatialConditions,
          _clothes,
          _difficultiesHolding);
      _saveUnfavorPoints();
    });
  }

  Future<void> _saveUnfavorPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        '${widget.userName}_unfavourablePoints', _unfavorablePoints);
    ///print("現在分數：$_unfavorablePoints");
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
          titleText: "不良工作條件",
          showActionButton: false,
          actionButtonCallback: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataView()),
            );*/
          },
          actionButtonIcon: Icons.help_rounded,
        ),
        body: Column(
          children: [
            const LinearProgressIndicator(
              value: 5 / 7,
              valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),
              backgroundColor: Color(0xffd9d9d9),
              minHeight: 5,
            ),
            ProgressBar(
              labelText: "$_unfavorablePoints分 / 13分",
              current: _unfavorablePoints.toDouble(),
              max: 13,
              barSize: 40,
              textSize: 18,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: const Text(
                                '手或手臂關節已達到極限',
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: const Text(
                                                    "關節達極限範例",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.all(30),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                          "assets/image/joint1.png"),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Image.asset(
                                                          "assets/image/joint2.png"),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Image.asset(
                                                          "assets/image/joint3.png"),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                  alignment: Alignment.bottomRight,
                                                  child: TextButton(
                                                    child: const Text("關閉"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                )
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/unfavorJoint.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        // OptionSlider(
                        //   valueHeight: 100,
                        //   valueWidth: 200,
                        //   valueFontSize: 25,
                        //   options: u1Texts,
                        //   onSelected: (value) {
                        //     _joint = value;
                        //     _update();
                        //   },
                        // ),
                        OptionButton(
                          initOption: u1Texts[0],
                          options: u1Texts,
                          ///intervalWidth: 0.03,
                          ///buttonWidth: 0.4,
                          onSelected: (value) {
                            _joint = value;
                            _update();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:50),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: const Text(
                                  "負重難以抓取/需要更大的力量",
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) {
                                        return Center(
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: Container(
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: const Text(
                                                      "負重難以抓取/需要更大的力量",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Table(
                                                          border: TableBorder.all(),
                                                          defaultVerticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          columnWidths: const <int,
                                                              TableColumnWidth>{
                                                            0: FixedColumnWidth(70.0),
                                                            1: FlexColumnWidth(),
                                                          },
                                                          children: const [
                                                            TableRow(children: [
                                                              TableCell(
                                                                  child: Center(
                                                                      child: Text(
                                                                          '稍微'))),
                                                              TableCell(
                                                                  child: Center(
                                                                      child: Text(
                                                                          '負重不易抓握\n需要更大的握力\n沒有成形的握把、工作手套'))),
                                                            ]),
                                                            TableRow(children: [
                                                              TableCell(
                                                                  child: Center(
                                                                      child: Text(
                                                                          '非常'))),
                                                              TableCell(
                                                                  child: Center(
                                                                      child: Text(
                                                                          '負重幾乎無法被抓握\n物體邊緣濕滑、柔軟、鋒利\n沒有握把、工作手套\n握把、工作手套不合適'))),
                                                            ]),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/hard.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        // OptionSlider(
                        //   valueHeight: 100,
                        //   valueWidth: 200,
                        //   valueFontSize: 25,
                        //   options: u2Texts,
                        //   onSelected: (value) {
                        //     _forceTransfer = value;
                        //     _update();
                        //   },
                        // ),
                        OptionButton(
                          initOption: u2Texts[0],
                          options: u2Texts,
                          ///intervalWidth: 0.03,
                          ///buttonWidth: 0.4,
                          onSelected: (value) {
                            _forceTransfer = value;
                            _update();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: const Text(
                                  '不良天氣條件',
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) {
                                        return Center(
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: Container(
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: const Text(
                                                      "不良天氣條件",
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
                                                        "環境、風的溫度過高或過低\n環境過於乾燥或潮濕"),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),

                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/weather.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        // OptionSlider(
                        //   valueHeight: 100,
                        //   valueWidth: 200,
                        //   valueFontSize: 25,
                        //   options: u3Texts,
                        //   onSelected: (value) {
                        //     _unfavorableWeatherConditions = value;
                        //     _update();
                        //   },
                        // ),
                        OptionButton(
                          initOption: u3Texts[0],
                          options: u3Texts,
                          intervalWidth: 0.03,
                          buttonWidth: 0.4,
                          onSelected: (value) {
                            _unfavorableWeatherConditions = value;
                            _update();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "空間條件",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            width:
                                            MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: const Text(
                                                    "空間條件",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Table(
                                                        border: TableBorder.all(),
                                                        defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                        columnWidths: const <int,
                                                            TableColumnWidth>{
                                                          0: FixedColumnWidth(70.0),
                                                          1: FlexColumnWidth(),
                                                        },
                                                        children: const [
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '受限'))),
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '工作區域小於 1.5 平方公尺，地板中等髒污和輕度不平整，輕微傾斜（不超過5°），穩定性略有受限，負重必須精確定位'))),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '不良'))),
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '活動的自由度嚴重受限、可活動的高度不足，工作空間侷限，地板非常骯髒、不平整或粗糙地面，如碎石、小坑洞，傾斜5～10°，穩定度受限，負重需放置非常精確'))),
                                                          ]),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/spatial.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        // OptionSlider(
                        //   valueHeight: 100,
                        //   valueWidth: 200,
                        //   valueFontSize: 25,
                        //   options: u4Texts,
                        //   onSelected: (value) {
                        //     _spatialConditions = value;
                        //     _update();
                        //   },
                        // ),
                        OptionButton(
                          initOption: u4Texts[0],
                          options: u4Texts,
                          ///intervalWidth: 0.03,
                          ///buttonWidth: 0.4,
                          onSelected: (value) {
                            _spatialConditions = value;
                            _update();
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                '額外的衣物或裝備',
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            width:
                                            MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: const Text(
                                                    "額外的衣物或裝備",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                  child: const Text(
                                                      "穿著可能造成身體額外負擔的裝備或是衣物\n如厚重雨衣、全身防護裝、呼吸防具、裝備腰帶"
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/equipment.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        // OptionSlider(
                        //   valueHeight: 100,
                        //   valueWidth: 150,
                        //   valueFontSize: 25,
                        //   options: u5Texts,
                        //   onSelected: (value) {
                        //     _clothes = value;
                        //     _update();
                        //   },
                        // ),
                        OptionButton(
                          initOption: u5Texts[0],
                          options: u5Texts,
                          intervalWidth: 0.03,
                          buttonWidth: 0.4,
                          onSelected: (value) {
                            _clothes = value;
                            _update();
                          },
                        ),
                      ]
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                '握持、搬運情況',
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            width:
                                            MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: const Text(
                                                    "握持、搬運情況",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Table(
                                                        border: TableBorder.all(),
                                                        defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                        columnWidths: const <int,
                                                            TableColumnWidth>{
                                                          0: FixedColumnWidth(70.0),
                                                          1: FlexColumnWidth(),
                                                        },
                                                        children: const [
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '困難'))),
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '握持持續5～10秒\n搬運距離2～5公尺'))),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '艱難'))),
                                                            TableCell(
                                                                child: Center(
                                                                    child: Text(
                                                                        '握持持續超過10秒\n搬運距離超過5公尺'))),
                                                          ]),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //border: Border.all(width: 5, color: const Color(0xff8a8588)),
                          ),
                          width: 340,
                          height: 150,
                          child: Image.asset(
                            "assets/image/holding.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        // OptionSlider(
                        //   valueHeight: 100,
                        //   valueWidth: 200,
                        //   valueFontSize: 25,
                        //   options: u6Texts,
                        //   onSelected: (value) {
                        //     _difficultiesHolding = value;
                        //     _update();
                        //   },
                        // ),
                        OptionButton(
                          initOption: u6Texts[0],
                          options: u6Texts,
                          ///intervalWidth: 0.03,
                          ///buttonWidth: 0.4,
                          onSelected: (value) {
                            _difficultiesHolding = value;
                            _update();
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )
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
                  await _saveUnfavorPoints();
                  Navigator.pop(context, true); // 傳遞 true 表示有更新
                },
                child: const Text(
                  "保存修改",
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: 150,
            //       height: 60,
            //       margin:
            //           const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //             shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            //                 RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(30),
            //                     side: const BorderSide(
            //                         color: Colors.transparent)))),
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         child: const Text(
            //           "返回",
            //           style:
            //               TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 30),
            //     Container(
            //       width: 150,
            //       height: 60,
            //       margin:
            //           const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //             shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            //                 RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(30),
            //                     side: const BorderSide(
            //                         color: Colors.transparent)))),
            //         onPressed: () async {
            //           await _saveUnfavorPoints();
            //           Navigator.pop(context, true); // 傳遞 true 表示有更新
            //         },
            //         child: const Text(
            //           "保存",
            //           style:
            //               TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ));
  }
}
