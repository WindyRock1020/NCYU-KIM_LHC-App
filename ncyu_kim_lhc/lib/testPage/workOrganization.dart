import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/testPage/result.dart';
import 'package:ncyu_kim_lhc/widget/optionButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';

class WorkOrganization extends StatefulWidget {
  const WorkOrganization({super.key});
  @override
  State<WorkOrganization> createState() => _WorkOrganizationState();
}

class _WorkOrganizationState extends State<WorkOrganization> {
  // double _organSliderValue = 0.0;
  int _organPoints = 0;
  String _selectedOrganText = "良好";
  List<String> organTexts =["良好", "受限", "不良"];
  int calculateOrgan(String organ){
    Map<String,int> organPoints = {"良好":0, "受限":2, "不良":4};
    return organPoints[organ] ?? 0;
  }
  void _update(){
    setState(() {
      _organPoints = calculateOrgan(_selectedOrganText);
      _saveOrganPoints();
    });
  }
  Future<void> _saveOrganPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('organPoints', _organPoints);
  }
  @override
  void initState() {
    super.initState();
    _update();
    _organPoints = calculateOrgan(_selectedOrganText);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        titleText: "工作時間分配",
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
          const LinearProgressIndicator(value: 6/7,valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),backgroundColor: Color(0xffd9d9d9),minHeight: 5,),
          //ProgressBar(current: 6, max: 7),
          ProgressBar(
            labelText: "$_organPoints分 / 4分",
            textSize: 20,
            current: _organPoints,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("工作時間分配",
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
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
                                              "工作時間分配",
                                              style: TextStyle(
                                                fontSize: 24,
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
                                                 defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                 columnWidths: const <int, TableColumnWidth>{
                                                   0: FixedColumnWidth(70.0),
                                                   1: FlexColumnWidth(),
                                                 },
                                                 children: const [
                                                   TableRow(
                                                     children: [
                                                       TableCell(child: Center(child: Text('良好'))),
                                                       TableCell(child: Center(child: Text('負荷由於其他活動而頻繁變化，並包含多種工作型態，無在一天內集中進行單一種高強度工作負荷'))),
                                                     ]
                                                   ),
                                                   TableRow(
                                                       children: [
                                                         TableCell(child: Center(child: Text('受限'))),
                                                         TableCell(child: Center(child: Text('負荷鮮少由於其他活動而變化，偶爾在一天內集中進行單一種高強度工作負荷'))),
                                                       ]
                                                   ),
                                                   TableRow(
                                                       children: [
                                                         TableCell(child: Center(child: Text('不良'))),
                                                         TableCell(child: Center(child: Text('負荷幾乎沒有由於其他活動而變化，經常在一天內集中進行單一種高強度工作負荷，並常達到負荷峰值'))),
                                                       ]
                                                   ),
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
                    /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 5, color: const Color(0xff8a8588)),
                    ),*/
                    width: 340,
                    height: 150,
                    child: Image.asset(
                      "assets/image/Organ.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  /*OptionSlider(
                    valueFontSize:25,
                    valueWidth: 340,
                    options: organTexts,
                    onSelected: (value) {
                      _selectedOrganText = value;
                      _update();
                    },
                  ),*/
                  OptionButton(
                    initOption: organTexts[0],
                    options: organTexts,
                    onSelected: (value) {
                      _selectedOrganText = value;
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
                      builder: (context) => const Result()),
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
          //       margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
          //       width: 150,
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
          //                 builder: (context) => const Result()),
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
