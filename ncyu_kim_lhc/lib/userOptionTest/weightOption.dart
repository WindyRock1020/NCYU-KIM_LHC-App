import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';
class WeightOption extends StatefulWidget {
  final String userName;
  const WeightOption({super.key,required this.userName});

  @override
  State<WeightOption> createState() => _EffectiveLoadWeight();
}

class _EffectiveLoadWeight extends State<WeightOption> {
  final PageController _loadWeightController = PageController();
  String _gender = "female";
  String _weight = "3～5";
  int _loadWeightPoints = 4;

  final List<String> genderTexts = ["female", "male"];
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

  void _update(){
    setState(() {
      _loadWeightPoints = calculateWeight(_gender, _weight);
      _saveLoadWeightPoints();
    });
  }
  Future<void> _saveLoadWeightPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.userName}_loadWeightPoints', _loadWeightPoints);
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
        titleText: "Effective load weight",
        showActionButton: false,
        actionButtonCallback: () {},
        actionButtonIcon: Icons.help_rounded,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LinearProgressIndicator(
            value: 1 / 7,
            valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),
            backgroundColor: Color(0xffd9d9d9),
            minHeight: 5,
          ),
          //ProgressBar(current: 1, max: 7,),
          ProgressBar(
            current: calculateWeight(_gender,_weight),
            max: 100,
            barSize: 40,
            labelText: "Effective load weight: ${_loadWeightPoints.toString().padLeft(3,' ')} points",
            textSize: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'biological gender',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xff7392ff),
                    ),
                    width: 200,
                    height: 200,
                    child: PageView(
                      controller: _loadWeightController,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/$_gender.svg",
                          width: 100,
                          height: 100,
                          color: Colors.black,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ],
                    ),
                  ),
                  OptionSlider(
                    valueWidth: 0,
                    valueHeight: 0,
                    options: genderTexts,
                    onSelected: (value){
                      setState(() {
                        _gender =value;
                        _update();

                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Effective load weight',
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
                                height: 200,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                width: MediaQuery.of(context).size.width * 1,
                                child: Image.asset(
                                    "assets/image/loadWeightList.png"),
                              ),
                            );
                          },
                          icon: Icon(Icons.help_rounded),
                        ),
                      ],
                    ),
                  ),
                  OptionSlider(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 60,
                margin:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Colors.transparent)))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Previous",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                width: 150,
                height: 60,
                margin:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Colors.transparent)))),
                  onPressed: () async {
                    await _saveLoadWeightPoints();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Next",
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
