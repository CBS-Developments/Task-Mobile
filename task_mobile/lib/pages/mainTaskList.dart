import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/pages/openTask.dart';
import 'dart:convert';

import 'createMainTask.dart';
import 'createSubTask.dart';

class MainTaskList extends StatefulWidget {

  // const MainTaskList({required Key key}) : super(key: key);

  @override
  State<MainTaskList> createState() => _MainTaskListState();
}

class _MainTaskListState extends State<MainTaskList> {

  List<MainTask> mainTaskList = [];
  TextEditingController taskListController = TextEditingController();
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
                  height: 55,
                  padding: const EdgeInsets.all(4),
                  child: TextField(
                    controller: taskListController,
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
                        //borderRadius: BorderRadius circular(5.0),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Divider(),
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
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpenTaskPage(task: task,
                                userRoleForDelete: userRole,
                                userName: userName,
                                firstName: firstName,
                                lastName: lastName,),
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
                        // Add a new button to open a dialog
                        IconButton(
                          icon: Icon(Icons.menu_open_rounded, color: Colors.teal),
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
              builder: (context) => CreateMainTask(
                lastName: lastName, username: userName, firstName: firstName,
              ),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Method to open an info dialog
  void _openInfoDialog(MainTask task, var taskTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText('$taskTitle',
          style: TextStyle(
            fontSize: 18
          ),),
          content: SelectableText(
              'Task ID: ${task.taskId}\n\nAssign To: ${task.assignTo}\n\nTask Description: ${task.task_description}'), // Customize the content as needed
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Create Sub Task',
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('main_task_id', task.taskId);
                prefs.setString('main_task_title', task.taskTitle);
                prefs.setString('intent_from', "main_dashboard");
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  CreateSubTask(username: userName,
                        firstName: firstName,
                        lastName: lastName,
                        mainTaskId: task.taskId,
                        task: task, userRole: userRole,
                        )),
                );
              },
            ),
            TextButton(
              child: const Text(
                'Edit Main Task',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('main_task_id', task.taskId);
                prefs.setString('task_title', task.taskTitle);
                prefs.setString('task_type', task.taskType);
                prefs.setString('task_type_name', task.taskTypeName);
                prefs.setString('task_create_by', task.taskCreateBy);
                prefs.setString('task_create_date', task.taskCreateDate);
                prefs.setString(
                    'task_created_timestamp', task.taskCreatedTimestamp);
                prefs.setString('task_status', task.taskStatus);
                prefs.setString('task_status_name', task.taskStatusName);
                prefs.setString('due_date', task.dueDate);
                prefs.setString('assign_to', task.assignTo);
                prefs.setString('source_from', task.sourceFrom);
                prefs.setString('company', task.company);
                if (!mounted) return;
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const EditMainTask()),
                // );
              },
            ),
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

