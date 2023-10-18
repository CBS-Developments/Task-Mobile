import 'package:flutter/material.dart';

import '../methods/sizes.dart';

class MainTaskList extends StatefulWidget {
  const MainTaskList({Key? key}) : super(key: key);

  @override
  State<MainTaskList> createState() => _MainTaskListState();
}

class _MainTaskListState extends State<MainTaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1.0,
      ),
      body: Container(
        color: Colors.white,
        width: getPageWidth(context),
        height: getPageHeight(context),
      )
    );
  }
}
