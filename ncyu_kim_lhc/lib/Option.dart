import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Option extends StatefulWidget {
  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  _loadUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('uploadUrl') ?? 'http://120.110.114.17:8080';
    setState(() {
      _urlController.text = url;
    });
  }

  _saveUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uploadUrl', _urlController.text);
    Fluttertoast.showToast(
      msg: "URL已保存",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: const Color(0xff7392ff),
      fontSize: 20.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定URL"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: '輸入URL',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUrl,
              child: Text('保存URL'),
            ),
          ],
        ),
      ),
    );
  }
}
