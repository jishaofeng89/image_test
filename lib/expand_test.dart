import 'package:flutter/material.dart';

class ExpandTest extends StatefulWidget {
  ExpandTest({Key key}) : super(key: key);

  _ExpandTestState createState() => _ExpandTestState();
}

class _ExpandTestState extends State<ExpandTest> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Expanded(
    //     child: Text('expanded是否可以单独使用，还是必须要在某个widget里面'),
    //   ),
    // );

    // 还是报错：Expanded widgets must be placed inside Flex widgets
    // return Scaffold(
    //   body: Container(
    //     child: Expanded(
    //       child: Text('expanded是否可以单独使用，还是必须要在某个widget里面'),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Text('expanded是否可以单独使用，还是必须要在某个widget里面'),
          ),
        ],
      ),
    );
  }
}