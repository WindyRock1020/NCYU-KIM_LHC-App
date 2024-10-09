import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';

class UnfavorOption extends StatefulWidget {
  final String userName;
  const UnfavorOption({super.key, required this.userName});

  @override
  State<UnfavorOption> createState() => _UnfavorableWorkingConditions();
}

class _UnfavorableWorkingConditions extends State<UnfavorOption> {
  String _joint = "Not";
  String _forceTransfer = "Normal";
  String _unfavorableWeatherConditions = "No";
  String _spatialConditions = "Normal";
  String _clothes = "No";
  String _difficultiesHolding = "Normal";
  int _unfavorablePoints = 0;

  List<String> u1Texts = ["None", "Occasionally", "Frequently"];
  List<String> u2Texts = ["Normal", "Restricted", "Considerably hindered"];
  List<String> u3Texts = ["No", "Yes"];
  List<String> u4Texts = ["Normal", "Restricted", "Unfavorable"];
  List<String> u5Texts = ["No", "Yes"];
  List<String> u6Texts = ["Normal", "Difficult", "Significant difficult"];

  Map<String, int> u1Points = {"None": 0, "Occasionally": 1, "Frequently": 2};
  Map<String, int> u2Points = {
    "Normal": 0,
    "Restricted": 1,
    "Considerably hindered": 2
  };
  Map<String, int> u3Points = {"No": 0, "Yes": 1};
  Map<String, int> u4Points = {"Normal": 0, "Restricted": 1, "Unfavorable": 2};
  Map<String, int> u5Points = {"No": 0, "Yes": 1};
  Map<String, int> u6Points = {
    "Normal": 0,
    "Difficult": 2,
    "Significant difficult": 5
  };

  int calculateUnfavorable(String u1, String u2, String u3, String u4, String u5, String u6) {
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
          _joint, _forceTransfer, _unfavorableWeatherConditions, _spatialConditions, _clothes, _difficultiesHolding);
      _saveUnfavorPoints();
    });
  }

  Future<void> _saveUnfavorPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.userName}_unfavourablePoints', _unfavorablePoints);
    print("現在分數：$_unfavorablePoints");
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
          titleText: "Unfavourable Conditions",
          showActionButton: false,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: 5 / 7,
              valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),
              backgroundColor: Color(0xffd9d9d9),
              minHeight: 5,
            ),
            ProgressBar(
              labelText: "Unfavorable working conditions: $_unfavorablePoints points",
              current: _unfavorablePoints.toDouble(),
              max: 13,
              barSize: 40,
              textSize: 15,
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'The joint of hand or arm has \nreached its limit: ',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${u1Points[_joint] ?? 0} points",
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Color(0xffffffff),
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                  ),
                                  isDismissible: true,
                                  enableDrag: true,
                                  builder: (context) => Container(
                                      height: 550,
                                      width: MediaQuery.of(context).size.width * 1,
                                      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                      child: Column(
                                        children: [
                                          Text(
                                            'hand joint reach the limit',
                                            style: TextStyle(fontSize: 25),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Image.asset("assets/image/joint1.png"),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Image.asset("assets/image/joint2.png"),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Image.asset("assets/image/joint3.png"),
                                        ],
                                      )),
                                );
                              },
                              icon: Icon(Icons.help_rounded)),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Color(0xff8a8588)),
                        ),
                        width: 340,
                        height: 150,
                        child: Image.asset(
                          "assets/image/twist.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      OptionSlider(
                        valueHeight: 100,
                        valueWidth: 200,
                        valueFontSize: 25,
                        options: u1Texts,
                        onSelected: (value) {
                          _joint = value;
                          _update();
                        },
                      ),
                      Container(
                        child: Text(
                          "Force transfer/application",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${u2Points[_forceTransfer] ?? 0} points',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Color(0xffffffff),
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                    ),
                                    isDismissible: true,
                                    enableDrag: true,
                                    builder: (context) => Container(
                                        height: 550,
                                        width: MediaQuery.of(context).size.width * 1,
                                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Force transfer/application',
                                              style: TextStyle(fontSize: 25),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Restricted: loads difficult to grip / greater holding forces required / no shaped grips / work gloves.",
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Considerably hindered: loads hardly possible to grip / slippery, soft, sharp edges / no/unsuiPoints grips / work gloves.",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  );
                                },
                                icon: Icon(Icons.help_rounded)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Color(0xff8a8588)),
                        ),
                        width: 340,
                        height: 150,
                        child: Image.asset(
                          "assets/image/body_center.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      OptionSlider(
                        valueHeight: 100,
                        valueWidth: 200,
                        valueFontSize: 25,
                        options: u2Texts,
                        onSelected: (value) {
                          _forceTransfer = value;
                          _update();
                        },
                      ),
                      Container(
                        child: Text(
                          'Unfavorable weather conditions',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${u3Points[_unfavorableWeatherConditions] ?? 0} points',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Color(0xffffffff),
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                    ),
                                    isDismissible: true,
                                    enableDrag: true,
                                    builder: (context) => Container(
                                        height: 550,
                                        width: MediaQuery.of(context).size.width * 1,
                                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Unfavorable weather conditions',
                                              style: TextStyle(fontSize: 25),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "unfavourable weather conditions and/or physical workloads caused by heat, draught, cold, wet.\n",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  );
                                },
                                icon: Icon(Icons.help_rounded)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Color(0xff8a8588)),
                        ),
                        width: 340,
                        height: 150,
                        child: Image.asset(
                          "assets/image/arm_raise.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      OptionSlider(
                        valueHeight: 100,
                        valueWidth: 200,
                        valueFontSize: 25,
                        options: u3Texts,
                        onSelected: (value) {
                          _unfavorableWeatherConditions = value;
                          _update();
                        },
                      ),
                      Container(
                        child: Text(
                          'Spatial conditions',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${u4Points[_spatialConditions] ?? 0} points",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Color(0xffffffff),
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                    ),
                                    isDismissible: true,
                                    enableDrag: true,
                                    builder: (context) => Container(
                                        height: 550,
                                        width: MediaQuery.of(context).size.width * 1,
                                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Spatial conditions',
                                              style: TextStyle(fontSize: 25),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Restricted: work area of less than 1.5 m², floor is moderately dirty and slightly uneven, slight inclination of up to 5°, slightly restricted stability, load must be positioned precisely.\n",
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "Unfavorable: significantly restricted freedom of movement or space for movement is not high enough, working in confined spaces, floor is very dirty, uneven or roughly cobbled, steps / potholes, stronger inclination of 5-10°, restricted stability, load must be positioned very precisely.\n",
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        )),
                                  );
                                },
                                icon: Icon(Icons.help_rounded)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Color(0xff8a8588)),
                        ),
                        width: 340,
                        height: 150,
                        child: Image.asset(
                          "assets/image/above_shoulder.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      OptionSlider(
                        valueHeight: 100,
                        valueWidth: 200,
                        valueFontSize: 25,
                        options: u4Texts,
                        onSelected: (value) {
                          _spatialConditions = value;
                          _update();
                        },
                      ),
                      Container(
                        child: Text(
                          'Additional clothes or equipment',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${u5Points[_clothes] ?? 0} points",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Color(0xffffffff),
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                    ),
                                    isDismissible: true,
                                    enableDrag: true,
                                    builder: (context) => Container(
                                        height: 550,
                                        width: MediaQuery.of(context).size.width * 1,
                                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Additional clothes or equipment',
                                              style: TextStyle(fontSize: 25),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "additional physical workload due to impairing clothes or equipment (e.g. when wearing heavy rain jackets, whole-body protection suits, respiratory protective equipment, tool belts or the like).",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  );
                                },
                                icon: Icon(Icons.help_rounded)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Color(0xff8a8588)),
                        ),
                        width: 340,
                        height: 150,
                        child: Image.asset(
                          "assets/image/body_center.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      OptionSlider(
                        valueHeight: 100,
                        valueWidth: 150,
                        valueFontSize: 25,
                        options: u5Texts,
                        onSelected: (value) {
                          _clothes = value;
                          _update();
                        },
                      ),
                      Container(
                        child: Text(
                          'Difficulties due to holding/carrying',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${u6Points[_difficultiesHolding] ?? 0} points",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Color(0xffffffff),
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                    ),
                                    isDismissible: true,
                                    enableDrag: true,
                                    builder: (context) => Container(
                                        height: 550,
                                        width: MediaQuery.of(context).size.width * 1,
                                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Difficulties due to holding/carrying',
                                              style: TextStyle(fontSize: 25),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Difficult: The load has to be held between > 5 and 10 seconds or carried over a distance between > 2 m and 5 m.\n",
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Significant difficult: The load has to be held > 10 seconds or carried over a distance > 5 m. ",
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        )),
                                  );
                                },
                                icon: Icon(Icons.help_rounded)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 5, color: Color(0xff8a8588)),
                        ),
                        width: 340,
                        height: 150,
                        child: Image.asset(
                          "assets/image/body_center.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      OptionSlider(
                        valueHeight: 100,
                        valueWidth: 200,
                        valueFontSize: 25,
                        options: u6Texts,
                        onSelected: (value) {
                          _difficultiesHolding = value;
                          _update();
                        },
                      ),
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(color: Colors.transparent)))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(color: Colors.transparent)))),
                    onPressed: () async {
                      await _saveUnfavorPoints();
                      Navigator.pop(context, true);  // 傳遞 true 表示有更新
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
