import 'package:flutter/material.dart';
import 'package:task_mobile/pages/subTaskList.dart';

import '../components/test.dart';
import 'createSubTask.dart';

class OpenSubTaskPage extends StatefulWidget {
  final String userRoleForDelete;
  final String userName;
  final String firstName;
  final String lastName;
  final Task task;

  const OpenSubTaskPage({Key? key, required this.userRoleForDelete, required this.userName, required this.firstName, required this.lastName, required this.task}) : super(key: key);

  @override
  State<OpenSubTaskPage> createState() => _OpenSubTaskPageState();
}

class _OpenSubTaskPageState extends State<OpenSubTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText(
          widget.task.taskTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1.0,
      ),
    );
  }
}
