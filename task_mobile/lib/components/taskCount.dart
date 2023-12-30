import 'package:flutter/material.dart';

import '../pages/createSubTask.dart';

class TaskCount extends StatefulWidget {
  const TaskCount({Key? key}) : super(key: key);

  @override
  State<TaskCount> createState() => _TaskCountState();
}

class _TaskCountState extends State<TaskCount> {
  List<MainTask> mainTaskList = [];

  int getPendingTaskCount() {
    return mainTaskList.where((task) => task.taskStatus == "0").length;
  }

  int getInProgressTaskCount() {
    return mainTaskList.where((task) => task.taskStatus == "1").length;
  }

  int getAllTaskCount() {
    return mainTaskList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green,), // Add your desired icon here
              SizedBox(width: 8), // Add some spacing between icon and text
              Text("All: ${getAllTaskCount()}"),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue,), // Add your desired icon here
              SizedBox(width: 8),
              Text("Progress: ${getInProgressTaskCount()}"),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Icon(Icons.pending, color: Colors.purple,), // Add your desired icon here
              SizedBox(width: 8),
              Text("Pending: ${getPendingTaskCount()}"),
            ],
          ),
        ),
      ],
    );
  }
}
