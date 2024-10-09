import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/appBar.dart';
import '../widget/settingCard.dart';
import '../user/viewReport.dart';
import 'userOption/handlingOption.dart';
import 'userOption/unfavorOption.dart';
import 'userOption/weightOption.dart';
import 'userOption/freqOption.dart';
import 'userOption/organOption.dart';

class UserDetail extends StatefulWidget {
  final String userName;

  const UserDetail({super.key, required this.userName});

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late TextEditingController _loadWeightPointsController;
  late TextEditingController _totalBodyPosturePointsController;
  late TextEditingController _frequencyPointsController;
  late TextEditingController _handlingPointsController;
  late TextEditingController _unfavourablePointsController;
  late TextEditingController _workOrganizationPointsController;

  @override
  void initState() {
    super.initState();
    _loadWeightPointsController = TextEditingController();
    _totalBodyPosturePointsController = TextEditingController();
    _frequencyPointsController = TextEditingController();
    _handlingPointsController = TextEditingController();
    _unfavourablePointsController = TextEditingController();
    _workOrganizationPointsController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loadWeightPointsController.text =
          prefs.getInt('${widget.userName}_loadWeightPoints')?.toString() ?? '0';
      _totalBodyPosturePointsController.text =
          prefs.getDouble('${widget.userName}_totalBodyPosturePoints')?.toString().replaceAll(".0", "") ?? '0';
      _frequencyPointsController.text =
          prefs.getDouble('${widget.userName}_frequencyPoints')?.toString().replaceAll(".0", "") ?? '0';
      _handlingPointsController.text =
          prefs.getInt('${widget.userName}_handlingPoints')?.toString() ?? '0';
      _unfavourablePointsController.text =
          prefs.getInt('${widget.userName}_unfavourablePoints')?.toString() ?? '0';
      _workOrganizationPointsController.text =
          prefs.getInt('${widget.userName}_workOrganizationPoints')?.toString() ?? '0';
    });
  }

  Future<void> _refreshData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loadWeightPointsController.text =
          prefs.getInt('${widget.userName}_loadWeightPoints')?.toString() ?? '0';
      _frequencyPointsController.text =
          prefs.getDouble('${widget.userName}_frequencyPoints')?.toString().replaceAll(".0", "") ?? '0';
      _workOrganizationPointsController.text =
          prefs.getInt('${widget.userName}_workOrganizationPoints')?.toString() ?? '0';
      _totalBodyPosturePointsController.text =
          prefs.getDouble('${widget.userName}_totalBodyPosturePoints')?.toString().replaceAll(".0", "") ?? '0';
      _handlingPointsController.text =
          prefs.getInt('${widget.userName}_handlingPoints')?.toString() ?? '0';
      _unfavourablePointsController.text =
          prefs.getInt('${widget.userName}_unfavourablePoints')?.toString() ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedAppBar(titleText: widget.userName),
        body: Column(
          children: [
            CheckCard(
              cardColor: Color(0xff7392ff),
              showMod:false,
              icon: Icons.accessibility_new,
              title: '身體姿勢',
              subtitle: _totalBodyPosturePointsController.text,
              textColor: Color(0xffd9d9d9),
              onTap: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           FreqOption(userName: widget.userName)),
                // );
                // await _refreshData();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SettingCard(
                      icon: CupertinoIcons.cube_box_fill,
                      title: '負重評級',
                      subtitle: _loadWeightPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WeightOption(userName: widget.userName)),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: CupertinoIcons.stopwatch_fill,
                      title: '時間評級',
                      subtitle: _frequencyPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FreqOption(userName: widget.userName)),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: Icons.back_hand,
                      title: '負重處理條件',
                      subtitle: _handlingPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoadHandlingOption(userName: widget.userName)),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: CupertinoIcons.xmark_circle_fill,
                      title: '不良工作條件',
                      subtitle: _unfavourablePointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UnfavorOption(userName: widget.userName)),
                        );
                        await _refreshData();
                      },
                    ),
                    SettingCard(
                      icon: Icons.handyman,
                      title: '工作時間分配',
                      subtitle: _workOrganizationPointsController.text,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrganOption(userName: widget.userName)),
                        );
                        await _refreshData();
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
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                  //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Colors.transparent)))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewReport(userName: widget.userName)),
                  );
                },
                child: const Text(
                  "查看評估結果",
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
            ),
          ],
        ));
  }
}
