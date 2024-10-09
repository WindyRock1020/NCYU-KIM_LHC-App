import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/testPage/unfavorableWorkingConditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';

class LoadHandlingOpttion extends StatefulWidget {
  final String userName;
  const LoadHandlingOpttion({super.key,required this.userName});
  @override
  State<LoadHandlingOpttion> createState() => _LoadHandlingOption();
}

class _LoadHandlingOption extends State<LoadHandlingOpttion> {
  String _selectedHandling = "Use both hands symmetrically";
  // int _handlingSliderValue = 0;
  int _handlingPoints = 0;
  final List<String> handlingTexts = ["Use both hands symmetrically", "Temporarily use one hand", "Always use one hand"];

  int calculatHandling(String hands){
    Map<String,int> handlingPoints = {"Use both hands symmetrically":0, "Temporarily use one hand":2, "Always use one hand":4};
    return handlingPoints[hands] ?? 0;
  }
  void _update(){
    setState(() {
      _handlingPoints = calculatHandling(_selectedHandling);
      _saveHandlingPoints();
    });
  }
  Future<void> _saveHandlingPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.userName}_handlingPoints',_handlingPoints);


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
        titleText: "Load handling conditions",
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LinearProgressIndicator(value: 4/7,valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),backgroundColor: Color(0xffd9d9d9),minHeight: 5,),
          //ProgressBar(current: 4, max: 7),
          ProgressBar(
            labelText: "Load handling conditions: $_handlingPoints points",
            textSize: 16,
            current: _handlingPoints,
            max: 4,
            barSize: 40,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    'Load handling conditions',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
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
                    "assets/image/lifting_with_both_hands.png",
                    fit: BoxFit.contain,
                  ),
                ),
                OptionSlider(
                  options: handlingTexts,
                  valueFontSize: 25,
                  onSelected: (value) {
                    _selectedHandling = value;
                    // _handlingSliderValue =  handlingTexts.indexOf(value);
                    _update();
                  },
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
                margin:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
                    //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                    //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Colors.transparent)))),
                  onPressed: () async {
                    await _saveHandlingPoints();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
