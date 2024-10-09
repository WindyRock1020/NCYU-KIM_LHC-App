import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userDetail.dart';
import '../widget/appBar.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usernames = prefs.getStringList('users') ?? [];
    List<Map<String, String>> loadedUsers = [];

    for (String username in usernames) {
      String gender = prefs.getString('${username}_gender') ?? "male";
      loadedUsers.add({"username": username, "gender": gender});
    }

    setState(() {
      users = loadedUsers;
    });
  }

  Future<void> _updateUsername(int index, String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldUsername = users[index]["username"]!;

    // 保存新用戶名及其資料
    await prefs.setInt('${newUsername}_loadWeightPoints', prefs.getInt('${oldUsername}_loadWeightPoints') ?? 0);
    await prefs.setDouble('${newUsername}_totalBodyPosturePoints', prefs.getDouble('${oldUsername}_totalBodyPosturePoints') ?? 0.0);
    await prefs.setDouble('${newUsername}_frequencyPoints', prefs.getDouble('${oldUsername}_frequencyPoints') ?? 0.0);
    await prefs.setInt('${newUsername}_handlingPoints', prefs.getInt('${oldUsername}_handlingPoints') ?? 0);
    await prefs.setInt('${newUsername}_unfavourablePoints', prefs.getInt('${oldUsername}_unfavourablePoints') ?? 0);
    await prefs.setInt('${newUsername}_workOrganizationPoints', prefs.getInt('${oldUsername}_workOrganizationPoints') ?? 0);
    await prefs.setString('${newUsername}_gender', prefs.getString('${oldUsername}_gender') ?? "male");

    // 刪除舊用戶名及其資料
    await prefs.remove('${oldUsername}_loadWeightPoints');
    await prefs.remove('${oldUsername}_totalBodyPosturePoints');
    await prefs.remove('${oldUsername}_frequencyPoints');
    await prefs.remove('${oldUsername}_handlingPoints');
    await prefs.remove('${oldUsername}_unfavourablePoints');
    await prefs.remove('${oldUsername}_workOrganizationPoints');
    await prefs.remove('${oldUsername}_gender');

    // 更新用戶名列表
    users[index]["username"] = newUsername;
    await prefs.setStringList('users', users.map((user) => user["username"]!).toList());
    setState(() {});
  }

  Future<void> _deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = users[index]["username"]!;

    // 刪除用戶名及其資料
    await prefs.remove('${username}_loadWeightPoints');
    await prefs.remove('${username}_totalBodyPosturePoints');
    await prefs.remove('${username}_frequencyPoints');
    await prefs.remove('${username}_handlingPoints');
    await prefs.remove('${username}_unfavourablePoints');
    await prefs.remove('${username}_workOrganizationPoints');
    await prefs.remove('${username}_gender');

    // 更新用戶名列表
    users.removeAt(index);
    await prefs.setStringList('users', users.map((user) => user["username"]!).toList());
    setState(() {});
  }

  void showEditUsernameDialog(BuildContext context, int index, String currentUsername) {
    TextEditingController controller = TextEditingController(text: currentUsername);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('修改名字'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "輸入新名字"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () async {
                await _updateUsername(index, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('刪除檢測紀錄'),
          content: const Text('是否要刪除檢測紀錄？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('刪除'),
              onPressed: () async {
                await _deleteUser(index);
                Navigator.of(context).pop();
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
        titleText: "檢測紀錄",
        showActionButton: false,
      ),
      body: users.isEmpty
          ? Container(
        alignment: Alignment.center,
        child: Text(
          "目前沒有檢測紀錄",
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          String username = users[index]["username"]!;
          String gender = users[index]["gender"]!;
          return Slidable(
            key: Key(username),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                Container(
                  width: 95,
                  height: 100,
                  child: SlidableAction(
                    onPressed: (context) => showEditUsernameDialog(context, index, username),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: '修改',
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: SlidableAction(
                    onPressed: (context) => showDeleteConfirmationDialog(context, index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: '刪除',
                  ),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetail(userName: username),
                  ),
                );
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  color: const Color(0xffd9d9d9),
                  margin: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/image/${gender}.png"),
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
            ),
          );
        },
      ),
    );
  }
}
