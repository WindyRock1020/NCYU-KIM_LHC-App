import 'dart:math';

import 'package:flutter/material.dart';
import './user/userList.dart';
import './user/userSelect.dart';

class RotateHomePage extends StatefulWidget {
  const RotateHomePage({super.key});

  @override
  State<RotateHomePage> createState() => _RotateHomePageState();
}

class _RotateHomePageState extends State<RotateHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: 75,),
                Container(
                  height: 300,
                  alignment: Alignment.topCenter,
                  child: Image.asset("assets/icon/launicon.png",width: 350,height: 300,),
                ),
                SizedBox(width: 100,),
                Column(
                  children: [
                    Container(
                      width:200,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                      ElevatedButton(
                        style: ButtonStyle(
                          //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                          //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(color: Colors.transparent)
                                ))),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserSelect()),
                          );
                        },
                        child: const Text("開始測試",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25),),
                      ),
                    ),
                    Container(
                      width:200,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 10),
                      child:
                      ElevatedButton(
                        style: ButtonStyle(
                          //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                          //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(color: Colors.transparent)
                                ))),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserList()),
                          );
                        },
                        child: const Text("使用者資料",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25),),
                      ),
                    ),
                    Container(
                      width:200,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                      ElevatedButton(
                        style: ButtonStyle(
                          //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                          //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(color: Colors.transparent)
                                ))),
                        onPressed: (){
                          /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserData()),
                  );*/
                        },
                        child: const Text("設定",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25),),
                      ),
                    ),
                  ],
                )
              ],
            ),

          ],
        )
    );
  }
}
