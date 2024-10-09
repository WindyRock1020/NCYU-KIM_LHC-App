import 'package:flutter/material.dart';
import 'package:ncyu_kim_lhc/testPage/effectiveLoadWeight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../testPage/passiveUser/passiveRecording.dart';
import '../testPage/passiveUser/userCheck.dart';
import '../widget/appBar.dart';

class UserSelect extends StatefulWidget {
  const UserSelect({super.key});

  @override
  _UserSelectState createState() => _UserSelectState();
}

class _UserSelectState extends State<UserSelect> {
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userList = prefs.getStringList('users') ?? [];
    List<Map<String, String>> loadedUsers = [];

    for (String username in userList) {
      String gender = prefs.getString('${username}_gender') ?? "None";
      loadedUsers.add({"username": username, "gender": gender});
    }

    setState(() {
      users = loadedUsers;
    });
  }

  Future<void> _addNewUser(String newUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      users.insert(0, {"username": newUser, "gender": "None"});
    });
    await prefs.setStringList('users', users.map((user) => user["username"]!).toList());
  }

  void showAddUserDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New User', style: TextStyle(fontSize: 40)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter username"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                String newUser = controller.text;
                if (newUser.isNotEmpty) {
                  await _addNewUser(newUser);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        titleText: "新增檢測/選擇紀錄",
        showActionButton: false,
      ),
      body: ListView.builder(
        itemCount: users.length + 1, // +1 for the "Add New User" option
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EffectiveLoadWeight()),
                );
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(top: 10, ),
                /*
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff7392ff), width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                 */
                child: Container(
                  color: const Color(0xffd9d9d9),
                  ///borderRadius: BorderRadius.circular(17),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("開始新檢測", style: TextStyle(fontSize: 25)),
                    ],
                  ),
                ),
              ),
            );
          } else {
            int userIndex = index - 1;
            String username = users[userIndex]["username"]!;
            String gender = users[userIndex]["gender"]!;
            return Container(
              height: 100,
              margin: const EdgeInsets.only(top: 10),
              child: Container(
                color: const Color(0xffd9d9d9),
                ///elevation: 0,
                margin: const EdgeInsets.all(0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserCheck(userName: username),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/image/$gender.png"),
                          radius: 30,
                        ),
                      ),
                      Expanded(
                        child: Text(username, style: const TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
