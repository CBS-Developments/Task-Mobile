import 'package:flutter/material.dart';

class EditMainTask extends StatefulWidget {
  const EditMainTask({Key? key}) : super(key: key);

  @override
  State<EditMainTask> createState() => _EditMainTaskState();
}

class _EditMainTaskState extends State<EditMainTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        'Edit Main Task',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 1.0,
    ),);
  }
}
