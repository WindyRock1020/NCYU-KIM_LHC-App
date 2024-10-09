import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/homePage.dart';
import 'package:ncyu_kim_lhc/widget/PointsChart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widget/appBar.dart';
import '../widget/dataCard.dart';

class Result extends StatefulWidget {
  const Result({super.key});
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int loadWeightPoints = 0;
  double totalBodyPosturePoints = 100;
  double frequencyPoints = 0;
  int handlingPoints = 0;
  int unfavourablePoints = 0;
  int workOrganizationPoints = 0;
  String gender = "male";
  bool isExpandedPoints = false;
  bool isExpandedSuggestion = false;

  @override
  void initState() {
    super.initState();
    _loadLoadWeightPoints();
  }

  Future<void> _loadLoadWeightPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadWeightPoints = prefs.getInt('loadWeightPoints') ?? 4;
      totalBodyPosturePoints =  prefs.getDouble('totalBodyPosturePoints') ?? 0;
      frequencyPoints = prefs.getDouble('freqPoints') ?? 1;
      handlingPoints = prefs.getInt('handlingPoints') ?? 0;
      unfavourablePoints = prefs.getInt('unfavorablePoints') ?? 0;
      workOrganizationPoints = prefs.getInt('organPoints') ?? 0;
      gender = prefs.getString('gender') ?? "your father";
    });
    ///print("性別：$gender");
  }

  Future<void> _saveUserData(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${username}_loadWeightPoints', loadWeightPoints);
    await prefs.setDouble('${username}_totalBodyPosturePoints', totalBodyPosturePoints);
    await prefs.setDouble('${username}_frequencyPoints', frequencyPoints);
    await prefs.setInt('${username}_handlingPoints', handlingPoints);
    await prefs.setInt('${username}_unfavourablePoints', unfavourablePoints);
    await prefs.setInt('${username}_workOrganizationPoints', workOrganizationPoints);
    await prefs.setString('${username}_gender', gender);

    List<String> users = prefs.getStringList('users') ?? [];
    if (!users.contains(username)) {
      users.add(username);
      await prefs.setStringList('users', users);
    }
    await Fluttertoast.showToast(
      msg: "測驗紀錄已儲存",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: const Color(0xff7392ff),
      fontSize: 20.0,
    );
  }

  Future<void> showSaveUserDialog() async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("保存測驗紀錄"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "輸入名字"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () async {
                await _saveUserData(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxLoadWeightPoints = 100;
    double maxTotalBodyPosturePoints = 26;
    double maxFrequencyPoints = 10;
    double maxUnfavourablePoints = 13;
    double maxHandlingPoints = 4;
    double maxWorkOrganizationPoints = 4;
    double finalRatingPoints = 0;
    finalRatingPoints = frequencyPoints *
        (loadWeightPoints +
            handlingPoints +
            totalBodyPosturePoints +
            workOrganizationPoints +
            unfavourablePoints);
    String riskScore = finalRatingPoints.toString();
    riskScore = riskScore.replaceAll(".0", "");

    Color riskColor = (() {
      if (finalRatingPoints < 20) {
        return const Color(0xff55bc72);
      } else if (finalRatingPoints < 40) {
        return const Color(0xff7ab137);
      } else if (finalRatingPoints < 100) {
        return const Color(0xfff6c445);
      } else {
        return const Color(0xffe45f2b);
      }
    })();

    /*
    String physicalOverloaded = (() {
      if (finalRatingPoints < 20) {
        return "Physical overload is unlikely.";
      } else if (finalRatingPoints < 50) {
        return "Physical overload is possible for less resilient persons.";
      } else if (finalRatingPoints < 100) {
        return "Physical overload is also possible for normally resilient.";
      } else {
        return "Physical overload is likely.";
      }
    })();
    String healthConsequences = (() {
      if (finalRatingPoints < 20) {
        return "No health risk is to be expected.";
      } else if (finalRatingPoints < 50) {
        return "Fatigue, low-grade adaptation problems which can be compensated for during leisure time.";
      } else if (finalRatingPoints < 100) {
        return "Disorders (pain), possibly including dysfunctions, reversible in most cases, without morphological manifestation.";
      } else {
        return "More pronounced disorders and/or dysfunctions, structural damage with pathological significance.";
      }
    })();
    String measures = (() {
      if (finalRatingPoints < 20) {
        return "None.";
      } else if (finalRatingPoints < 50) {
        return "For less resilient persons, workplace redesign and other prevention measures may be helpful.";
      } else if (finalRatingPoints < 100) {
        return "Workplace redesign and other prevention measures should be considered. ";
      } else {
        return "Workplace redesign measures are necessary. Other prevention measures should be considered.";
      }
    })();
     */
    String physicalOverloaded = (() {
      if (finalRatingPoints < 20) {
        return "生理過載可能性低";
      } else if (finalRatingPoints < 50) {
        return "對恢復能力較弱者，有生理過載可能性";
      } else if (finalRatingPoints < 100) {
        return "對一般族群有生理過載可能性";
      } else {
        return "生理過載極可能發生";
      }
    })();
    String healthConsequences = (() {
      if (finalRatingPoints < 20) {
        return "無預期健康疑慮";
      } else if (finalRatingPoints < 50) {
        return "疲勞、低度適應不良問題，可由休息時間做調適";
      } else if (finalRatingPoints < 100) {
        return "出現異常(如疼痛)，可能有功能障礙，大部分個案為可逆的，沒有型態學上的表現";
      } else {
        return "產生更明確的異常或功能障礙，身體結構上受損，有病態表現";
      }
    })();
    String measures = (() {
      if (finalRatingPoints < 20) {
        return "無需採取措施";
      } else if (finalRatingPoints < 50) {
        return "針對恢復能力較弱者進行工作再設計，以及其他預防措施";
      } else if (finalRatingPoints < 100) {
        return "建議進行工作再設計，以及其他預防措施";
      } else {
        return "需要進行工作再設計，以及其他預防措施";
      }
    })();

    List<Map<String, dynamic>> highestData = [
      {
        'title': '身體姿勢',
        'points': totalBodyPosturePoints,
        'maxPoints': maxTotalBodyPosturePoints,
        'Suggestion': '選擇不太費力的姿勢進行搬運'
      },
      {
        'title': '負重評級',
        'points': loadWeightPoints,
        'maxPoints': maxLoadWeightPoints,
        'Suggestion': '可以讓兩個人一起搬運，以降低單人負重，或將貨物分裝，以減少單件貨物的重量。'
      },
      {
        'title': '時間評級',
        'points': frequencyPoints,
        'maxPoints': maxFrequencyPoints,
        'Suggestion': '尋找可以幫助自動化、簡化或優化工作流程的技術解決方案'
      },
      {
        'title': '負重處理條件',
        'points': handlingPoints,
        'maxPoints': maxHandlingPoints,
        'Suggestion': '工作中應盡量平均地施力，防止其中一測施力過重造成危害'
      },
      {
        'title': '不良工作條件',
        'points': unfavourablePoints,
        'maxPoints': maxUnfavourablePoints,
        'Suggestion': '改善工作環境，調整姿勢、使用輔助工具，並採取防護措施，確保安全與舒適。'
      },
      {
        'title': '工作時間分配',
        'points': workOrganizationPoints,
        'maxPoints': maxWorkOrganizationPoints,
        'Suggestion': '與主管或同事討論工作安排，聽取意見和建議，及時調整工作計劃。'
      },
    ];
    // for (var percentage in highestData) {
    //   percentage['ratio'] =
    //       ((percentage['points'] / percentage['maxPoints']) * 100).round();
    // }
    highestData.sort((a, b) => b['points'].compareTo(a['points']));
    List<Map<String, dynamic>> topThreeData = highestData.take(3).toList();
    String topThreeText = topThreeData.map((top) {
      return "${top['title'].toString().padLeft(6,"　")}：${top['points'].toString().replaceAll(".0", "").padLeft(3,'  ')} 分";
    }).join("\n");
    List<List> topThreeSuggestions = topThreeData.map((data) {
      return [data['title']+"建議", data['Suggestion']];
    }).toList();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SharedAppBar(
          titleText: "評估結果",
          showActionButton: true,
          actionButtonCallback: () {
            showModalBottomSheet(
              backgroundColor: const Color(0xffffffff),
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              isDismissible: true,
              enableDrag: true,
              builder: (context) => SizedBox(
                  height: 550,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset("assets/image/riskList.png")],
                  )),
            );
          },
          actionButtonIcon: Icons.help_rounded,
        ),
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      children: [
                        //LinearProgressIndicator(value: 1,valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),backgroundColor: Color(0xffd9d9d9),minHeight: 5,),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 260,
                                height: 260,
                                child: CircularProgressIndicator(
                                  value: double.parse(riskScore) / 1470,
                                  strokeWidth: 10,
                                  //color: riskColor,
                                  valueColor: AlwaysStoppedAnimation(riskColor),
                                  backgroundColor: Colors.grey.shade400,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(125),
                                  color: riskColor,
                                ),
                                alignment: Alignment.center,
                                width: 250,
                                height: 250,
                                padding: const EdgeInsets.all(5),
                                //margin: const EdgeInsets.only(top: 50, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "風險等級分數",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xfffefaef),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "$riskScore 分",
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontSize: 50,
                                          color: Color(0xfffefaef),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 250,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            child:Image.asset(
                                'assets/image/風險等級.png',
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width*0.9
                            ),
                          ),
                        ),
                        CustomDataCard(
                            customIconData: CustomIcon.material(Icons.warning_rounded),
                            titleText: "最高風險評級",
                            ratingText: topThreeText,
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 20,
                            cardHeight: 220,
                            backgroundColor: riskColor,
                            textColor: Colors.black,
                            ratingAlign: TextAlign.start,
                        ),
                        Container(
                          //margin: EdgeInsets.symmetric(vertical: 30),
                          height: 400,
                          width: 300,
                          child: CustomPaint(
                            painter: RadarChartPainter(
                              bodyPosturePoints: totalBodyPosturePoints,
                              loadWeightPoints: loadWeightPoints.toDouble(),
                              frequencyPoints: frequencyPoints,
                              handlingPoints: handlingPoints.toDouble(),
                              unfavourablePoints: unfavourablePoints.toDouble(),
                              workOrganizationPoints: workOrganizationPoints.toDouble(),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExpandedPoints = !isExpandedPoints;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "各項評級",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  // textAlign: TextAlign.start,
                                ),
                                Icon(isExpandedPoints ? CupertinoIcons.arrowtriangle_up_fill : CupertinoIcons.arrowtriangle_down_fill,size: 30),
                              ],
                            ),
                          ),
                        ),
                        CustomDataCard(
                            customIconData: CustomIcon.svg("assets/icon/posture.svg"),
                            titleText: "身體姿勢",
                            ratingText: totalBodyPosturePoints.toString().replaceAll(".0", ""),
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 40,
                            textColor: Colors.black),
                        if(isExpandedPoints) ...[
                          CustomDataCard(
                              customIconData:
                              CustomIcon.cupertino(CupertinoIcons.stopwatch_fill),
                              titleText: "時間評級",
                              ratingText: frequencyPoints.toString().replaceAll(".0", ""),
                              textWeight: FontWeight.w500,
                              titleTextSize: 20,
                              ratingTextSize: 40,
                              textColor: Colors.black),
                          CustomDataCard(
                              customIconData:
                              CustomIcon.cupertino(CupertinoIcons.cube_box_fill),
                              titleText: "負重評級",
                              ratingText: "$loadWeightPoints",
                              textWeight: FontWeight.w500,
                              titleTextSize: 20,
                              ratingTextSize: 40,
                              textColor: Colors.black),
                          CustomDataCard(
                              customIconData: CustomIcon.svg("assets/icon/strength.svg"),
                              titleText: "負重處理條件",
                              ratingText: "$handlingPoints",
                              textWeight: FontWeight.w500,
                              titleTextSize: 20,
                              ratingTextSize: 40,
                              textColor: Colors.black),
                          CustomDataCard(
                              customIconData:
                              CustomIcon.cupertino(CupertinoIcons.xmark_circle_fill),
                              titleText: "不良工作條件",
                              ratingText: "$unfavourablePoints",
                              textWeight: FontWeight.w500,
                              titleTextSize: 20,
                              ratingTextSize: 40,
                              textColor: Colors.black),
                          CustomDataCard(
                              customIconData: CustomIcon.svg("assets/icon/organ.svg"),
                              titleText: "工作時間分配",
                              ratingText: "$workOrganizationPoints",
                              textWeight: FontWeight.w500,
                              titleTextSize: 20,
                              ratingTextSize: 40,
                              textColor: Colors.black),
                        ],
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExpandedSuggestion = !isExpandedSuggestion;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "各項建議",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  // textAlign: TextAlign.start,
                                ),
                                Icon(isExpandedSuggestion ? CupertinoIcons.arrowtriangle_up_fill : CupertinoIcons.arrowtriangle_down_fill,size: 30,),
                              ],
                            ),
                          ),
                        ),
                        CustomDataCard(
                          customIconData: CustomIcon.cupertino(CupertinoIcons.exclamationmark_circle_fill),
                          titleText: topThreeSuggestions[0][0] ,
                          ratingText: topThreeSuggestions[0][1],
                          textWeight: FontWeight.w500,
                          titleTextSize: 20,
                          ratingTextSize: 20,
                          textColor: Colors.black,
                          cardHeight: 220,
                          marginBetween: 30,
                        ),
                        CustomDataCard(
                          customIconData: CustomIcon.cupertino(CupertinoIcons.exclamationmark_circle_fill),
                          titleText: topThreeSuggestions[1][0] ,
                          ratingText: topThreeSuggestions[1][1],
                          textWeight: FontWeight.w500,
                          titleTextSize: 20,
                          ratingTextSize: 20,
                          textColor: Colors.black,
                          cardHeight: 220,
                          marginBetween: 30,
                        ),
                        CustomDataCard(
                          customIconData: CustomIcon.cupertino(CupertinoIcons.exclamationmark_circle_fill),
                          titleText: topThreeSuggestions[2][0] ,
                          ratingText: topThreeSuggestions[2][1],
                          textWeight: FontWeight.w500,
                          titleTextSize: 20,
                          ratingTextSize: 20,
                          textColor: Colors.black,
                          cardHeight: 220,
                          marginBetween: 30,
                        ),
                        if(isExpandedSuggestion) ...[
                          CustomDataCard(
                            customIconData:
                            CustomIcon.cupertino(CupertinoIcons.ellipses_bubble_fill),
                            titleText: "生理過載可能性",
                            ratingText: physicalOverloaded,
                            ratingAlign: TextAlign.start,
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 20,
                            textColor: Colors.black,
                            cardHeight: 220,
                            marginBetween: 30,
                          ),
                          CustomDataCard(
                            customIconData:
                            CustomIcon.material(Icons.health_and_safety_rounded),
                            titleText: "健康疑慮可能",
                            ratingText: healthConsequences,
                            ratingAlign: TextAlign.center,
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 20,
                            textColor: Colors.black,
                            cardHeight: 220,
                            marginBetween: 30,
                          ),
                          CustomDataCard(
                            customIconData: CustomIcon.cupertino(CupertinoIcons.exclamationmark_circle_fill),
                            titleText: "採取措施",
                            ratingText: measures,
                            ratingAlign: TextAlign.center,
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 20,
                            textColor: Colors.black,
                            cardHeight: 220,
                            marginBetween: 30,
                          ),
                        ],
                      ],
                    ),
                  ),
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
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
                      await showSaveUserDialog();
                    },
                    child: const Text(
                      "儲存紀錄",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                 SizedBox(
                   width: MediaQuery.of(context).size.width*0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
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
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "返回首頁",
                      style: TextStyle(
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}
