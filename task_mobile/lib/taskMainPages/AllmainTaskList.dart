import 'package:Workspace_Lite/pages/createMainTaskNew.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/createMainTask.dart';
import '../pages/createSubTask.dart';
import '../pages/openTask.dart';

class MainTaskList extends StatefulWidget {
  @override
  State<MainTaskList> createState() => _MainTaskListState();
}

class _MainTaskListState extends State<MainTaskList> {
  List<MainTask> mainTaskList = [];
  TextEditingController taskListController = TextEditingController();
  TextEditingController taskListController1 = TextEditingController();
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    getTaskList();
  }

  Color? _getColorForTaskTypeName(String taskTypeName) {
    Map<String, Color> colorMap = {
      'Top Urgent': Colors.red,
      'Medium': Colors.blue,
      'Regular': Colors.green,
      'Low': Colors.yellow,
    };
    return colorMap.containsKey(taskTypeName) ? colorMap[taskTypeName] : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Main Tasks:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 330,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 320,
                  height: 50,
                  padding: const EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: taskListController,
                    onChanged: (taskId) {
                      _searchTaskById(taskId);
                    },
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search By ID',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  width: 320,
                  height: 50,
                  padding: const EdgeInsets.only(top: 1),
                  child: TextField(
                    controller: taskListController1,
                    onChanged: (taskTitle) {
                      _searchTaskByName(taskTitle);
                    },
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search By Name',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mainTaskList.length,
              itemBuilder: (context, index) {
                MainTask task = mainTaskList[index];
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OpenTaskPage(
                                    task: task,
                                    userRoleForDelete: userRole,
                                    userName: userName,
                                    firstName: firstName,
                                    lastName: lastName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              task.taskTitle,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.double_arrow, size: 15, color: Colors.green[800],),
                              SizedBox(width: 5,),
                              Text(
                                '${task.taskStatusName}...',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Text(
                          'Due Date:',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          task.dueDate,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.flag, color: _getColorForTaskTypeName(task.taskTypeName)),
                          onPressed: () {
                            // Handle onPressed action for the flag button
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.menu_open_rounded, color: Colors.green[800]),
                          onPressed: () {
                            _openInfoDialog(task, task.taskTitle);
                          },
                        ),
                      ],
                    ),
                  ),

                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMainTaskPage()
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _searchTaskById(String taskId) {
    if (taskId.isEmpty) {
      // Reset the task list to its original state
      getTaskList();
    } else {
      // Filter the mainTaskList based on the entered task ID
      List<MainTask> filteredTasks = mainTaskList
          .where((task) => task.taskId.toString().contains(taskId))
          .toList();

      setState(() {
        // Update the mainTaskList with the filtered tasks
        mainTaskList = filteredTasks;
      });
    }
  }

  void _searchTaskByName(String taskTitle) {
    if (taskTitle.isEmpty) {
      // Reset the task list to its original state
      getTaskList();
    } else {
      // Filter the mainTaskList based on the entered task ID
      List<MainTask> filteredTasks = mainTaskList
          .where((task) => task.taskTitle.toString().contains(taskTitle))
          .toList();

      setState(() {
        // Update the mainTaskList with the filtered tasks
        mainTaskList = filteredTasks;
      });
    }
  }

  void _openInfoDialog(MainTask task, var taskTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText(
            '$taskTitle',
            style: const TextStyle(fontSize: 18),
          ),
          content: SelectableText(
              'Task ID: ${task.taskId}\n\nAssign To: ${task.assignTo}\n\nDescription: ${task.task_description}'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getTaskList() async {
    mainTaskList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/mainTaskList.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body) as List<dynamic>;
      setState(() {
        for (Map<String, dynamic> details in responseJson) {
          mainTaskList.add(MainTask.fromJson(details));
        }
        mainTaskList.sort(
                (a, b) => b.taskCreatedTimestamp.compareTo(a.taskCreatedTimestamp));
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

