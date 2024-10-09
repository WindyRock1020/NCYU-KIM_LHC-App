import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/PointsChart.dart';
import '../widget/appBar.dart';
import '../widget/dataCard.dart';

class ViewReport extends StatefulWidget {
  final String userName;
  const ViewReport({super.key,required this.userName});

  @override
  State<ViewReport> createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  int loadWeightPoints = 0;
  double totalBodyPosturePoints = 0;
  double frequencyPoints = 0;
  int handlingPoints = 0;
  int unfavourablePoints = 0;
  int workOrganizationPoints = 0;
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
      loadWeightPoints = prefs.getInt('${widget.userName}_loadWeightPoints') ?? 4;
      totalBodyPosturePoints =  prefs.getDouble('${widget.userName}_totalBodyPosturePoints') ?? 0;
      frequencyPoints = prefs.getDouble('${widget.userName}_frequencyPoints') ?? 1;
      handlingPoints = prefs.getInt('${widget.userName}_handlingPoints') ?? 0;
      unfavourablePoints = prefs.getInt('${widget.userName}_unfavourablePoints') ?? 0;
      workOrganizationPoints = prefs.getInt('${widget.userName}_workOrganizationPoints') ?? 0;
    });
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
        return "恢復能力較弱者有過載可能性";
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
        return "疲勞、低度適應不良問題，\n可由休息時間做調適";
      } else if (finalRatingPoints < 100) {
        return "出現異常(如疼痛)，可能有\n功能障礙，大部分個案為可逆的，\n沒有型態學上的表現";
      } else {
        return "產生更明確的異常或功能障礙，身體結構上受損，有病態表現";
      }
    })();
    String measures = (() {
      if (finalRatingPoints < 20) {
        return "無需採取措施";
      } else if (finalRatingPoints < 50) {
        return "針對恢復能力較弱者進行工作\n再設計，以及其他預防措施";
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
        'Suggestion': '可以讓兩個人一起搬運，以降\n低單人負重，或將貨物分裝，\n以減少單件貨物的重量。'
      },
      {
        'title': '時間評級',
        'points': frequencyPoints,
        'maxPoints': maxFrequencyPoints,
        'Suggestion': '選擇不太費力的姿勢進行搬運'
      },
      {
        'title': '負重處理條件',
        'points': handlingPoints,
        'maxPoints': maxHandlingPoints,
        'Suggestion': '工作中應盡量平均地施力，防\n止其中一測施力過重造成危害'
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
        'Suggestion': '選擇不太費力的姿勢進行搬運'
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
    print(topThreeSuggestions);

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
                                  color: riskColor,
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
                                padding:EdgeInsets.all(5),
                                //margin: EdgeInsets.only(top: 50, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "風險值分數",
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
                        Container(
                          //margin: EdgeInsets.symmetric(vertical: 10),
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
                        if (isExpandedPoints) ...[
                          CustomDataCard(
                              customIconData: CustomIcon.cupertino(CupertinoIcons.stopwatch_fill),
                              titleText: "時間評級",
                              ratingText: frequencyPoints.toString().replaceAll(".0", ""),
                              textWeight: FontWeight.w500,
                              titleTextSize: 20,
                              ratingTextSize: 40,
                              textColor: Colors.black),
                          CustomDataCard(
                              customIconData: CustomIcon.cupertino(CupertinoIcons.cube_box_fill),
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
                              customIconData: CustomIcon.cupertino(CupertinoIcons.xmark_circle_fill),
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
                            customIconData: CustomIcon.cupertino(CupertinoIcons.ellipses_bubble_fill),
                            titleText: "生理過載可能性",
                            ratingText: physicalOverloaded,
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 20,
                            textColor: Colors.black,
                            cardHeight: 220,
                            marginBetween: 30,
                            ratingAlignment: Alignment.bottomRight,
                          ),
                          CustomDataCard(
                            customIconData: CustomIcon.material(Icons.health_and_safety_rounded),
                            titleText: "健康疑慮可能",
                            ratingText: healthConsequences,
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
                            textWeight: FontWeight.w500,
                            titleTextSize: 20,
                            ratingTextSize: 20,
                            textColor: Colors.black,
                            cardHeight: 220,
                            marginBetween: 30,
                          ),

                          // ...topThreeData.map((data) {
                          //   return CustomDataCard(
                          //     customIconData: CustomIcon.cupertino(
                          //         CupertinoIcons.info_circle_fill),
                          //     titleText: "${data['title']}建議",
                          //     ratingText: data['Suggestion'],
                          //     textWeight: FontWeight.w500,
                          //     titleTextSize: 20,
                          //     ratingTextSize: 20,
                          //     textColor: Colors.black,
                          //     cardHeight: 200,
                          //     marginBetween: 30,
                          //   );
                          // }).toList(),
                        ],
                      ],
                    ),
                  ),
                )
            ),
          ],
        )
    );
  }
}