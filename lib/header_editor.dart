import 'package:flutter/material.dart';

class HeaderEditor extends StatefulWidget {
  HeaderEditor({Key key}) : super(key: key);

  _HeaderEditorState createState() => _HeaderEditorState();
}

class _HeaderEditorState extends State<HeaderEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的形象'),
      ),
      body: Center(
        child: Text('老美了'),
      ),
    );
  }
}