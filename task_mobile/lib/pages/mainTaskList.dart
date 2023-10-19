import 'package:flutter/material.dart';
import 'package:task_mobile/methods/colors.dart';

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
          'Taxation',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Main Tasks:',
                    style: TextStyle(
                      color: AppColor.tealLog,
                      fontSize: 20
                    ),)
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}