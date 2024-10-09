import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/testPage/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/appBar.dart';
import '../widget/optionSlider.dart';
import '../widget/progressBar.dart';

class OrganOption extends StatefulWidget {
  final String userName;
  const OrganOption({super.key, required this.userName});
  @override
  State<OrganOption> createState() => _OrganOptionState();
}

class _OrganOptionState extends State<OrganOption> {
  // double _organSliderValue = 0.0;
  int _organPoints = 0;
  String _selectedOrganText = "Good";
  List<String> organTexts =["Good", "Restricted", "Unfavorable"];
  int calculateOrgan(String organ){
    Map<String,int> organPoints = {"Good":0, "Restricted":2, "Unfavorable":4};
    return organPoints[organ] ?? 0;
  }
  void _update() {
    setState(() {
      _organPoints = calculateOrgan(_selectedOrganText);
    });
  }
  Future<void> _saveOrganPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.userName}_workOrganizationPoints', _organPoints);
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
        titleText: "Work organization",
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
          LinearProgressIndicator(value: 6/7,valueColor: AlwaysStoppedAnimation(Color(0xff0038ff)),backgroundColor: Color(0xffd9d9d9),minHeight: 5,),
          //ProgressBar(current: 6, max: 7),
          ProgressBar(
            labelText: "Work organization: $_organPoints points",
            textSize: 20,
            current: _organPoints,
            max: 4,
            barSize: 40,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Work organization",
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center),
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
                                height: 800,
                                width: MediaQuery.of(context).size.width * 1,
                                child: Column(
                                  children: [
                                    Text(
                                      'Work organization / temporal distribution',
                                      style: TextStyle(fontSize: 30),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Good: frequent variation of the physical workload situation due to other activities (including other types of physical workload) / without a tight sequence of higher physical workloads within one type of physical workload during a single working day.\n",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Restricted: rare variation of the physical workload situation due to other activities (including other types of physical workload) / occasional tight sequence of higher physical workloads within one type of physical workload during a single working day.\n",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Unfavourable: no/hardly any variation of the physical workload situation due to other activities (including other types of physical workload) / frequent tight sequence of higher physical workloads within one type of physical workload during a single working day with concurrent high load peaks.",
                                      textAlign: TextAlign.center,
                                    ),
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
                    "assets/image/body_center.png",
                    fit: BoxFit.contain,
                  ),
                ),
                OptionSlider(
                  valueFontSize:25,
                  options: organTexts,
                  onSelected: (value) {
                    _selectedOrganText = value;
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
                    await _saveOrganPoints();
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
