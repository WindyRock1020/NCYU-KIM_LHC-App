import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './user/userList.dart';
import './user/userSelect.dart';
import 'Option.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }
  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('歡迎使用'),
          content: const Text('為了獲得最好的使用體驗，建議使用長寬比為18:9或更高比例的手機做使用',style: TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print("現在$screenWidth");
    double scaleFactor = screenWidth / 392;
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.1),
              height: MediaQuery.of(context).size.width*0.8,
              alignment: Alignment.topCenter,
              child: Image.asset("assets/icon/launicon.png",width: MediaQuery.of(context).size.width*0.6,height: 250,),
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.1,),
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: MediaQuery.of(context).size.width*0.15,
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.03,horizontal: 10),
              child:
              ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.transparent)
                        ))),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserSelect()),
                  );
                },
                child: const Text("開始檢測",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25),),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: MediaQuery.of(context).size.width*0.15,
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.03,horizontal: 10),
              child:
              ElevatedButton(
                style: ButtonStyle(
                  //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                  //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.transparent)
                        ))),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserList()),
                  );
                },
                child: const Text("檢測紀錄",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25),),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              height: MediaQuery.of(context).size.width*0.15,
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.03,horizontal: 10),
              child:
              ElevatedButton(
                style: ButtonStyle(
                  //backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xff8a8588)),
                  //foregroundColor: const MaterialStatePropertyAll<Color>(Color(0xfffefaef)),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.transparent)
                        ))),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Option()),
                  );
                },
                child: Text("設定",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25 * scaleFactor),),
              ),
            ),
          ],
        )
    );
  }
}
