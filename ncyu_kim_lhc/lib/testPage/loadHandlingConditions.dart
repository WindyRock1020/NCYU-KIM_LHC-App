import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/testPage/unfavorableWorkingConditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';

class LoadHandlingConditions extends StatefulWidget {
  const LoadHandlingConditions({super.key});
  @override
  State<LoadHandlingConditions> createState() => _LoadHandlingConditions();
}

class _LoadHandlingConditions extends State<LoadHandlingConditions> {
  String _selectedHandling = "可使用雙手對稱負重";
  // int _handlingSliderValue = 0;
  int _handlingPoints = 0;
  final List<String> handlingTexts = ["可使用雙手對稱負重", "不對稱負重", "幾乎以單手負重"];

  int calculatHandling(String hands){
    Map<String,int> handlingPoints = {"可使用雙手對稱負重":0, "不對稱負重":2, "幾乎以單手負重":4};
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
    await prefs.setInt('handlingPoints', _handlingPoints);
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
        titleText: "負重處理條件",
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
          const LinearProgressIndicator(value: 4/7,valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),backgroundColor: Color(0xffd9d9d9),minHeight: 5,),
          //ProgressBar(current: 4, max: 7),
          ProgressBar(
            labelText: "$_handlingPoints分 / 4分",
            textSize: 20,
            current: _handlingPoints,
            max: 4,
            barSize: 40,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(30)
              ),
              width: MediaQuery.of(context).size.width*0.9,
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
                      // _handlingSliderValue =  handlingTexts.indexOf(value);
                      _update();
                    },
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
                      builder: (context) => const UnfavorableWorkingConditions()),
                );
              },
              child: const Text(
                "下一步",
                style:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
          //           style:
          //           TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: MediaQuery.of(context).size.width*0.05,),
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
          //                 builder: (context) => const UnfavorableWorkingConditions()),
          //           );
          //         },
          //         child: const Text(
          //           "下一步",
          //           style:
          //           TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
