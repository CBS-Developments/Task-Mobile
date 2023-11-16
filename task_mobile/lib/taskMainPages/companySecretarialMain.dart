import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/createMainTask.dart';
import '../pages/createSubTask.dart';
import 'AllmainTaskList.dart';
import '../pages/openTask.dart';

class SecretarialMain extends StatefulWidget {
  const SecretarialMain({Key? key}) : super(key: key);

  @override
  State<SecretarialMain> createState() => _SecretarialMainState();
}

class _SecretarialMainState extends State<SecretarialMain> {


  List<MainTask> mainTaskList = [];
  List<MainTask> searchResultAsMainTaskList = [];
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
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";
    });
    print('User Role In Table: $userRole');
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
          'Company Secretarial',
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
                        borderRadius: BorderRadius.circular(5.0),
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
                        IconButton(
                          icon: Icon(Icons.flag, color: _getColorForTaskTypeName(task.taskTypeName)),
                          onPressed: () {
                            // Handle onPressed action for the flag button
                          },
                        ),// Add a new button to open a dialog
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
        backgroundColor: Colors.teal, // Use the actual color, e.g., Colors.teal
        child: const Icon(Icons.add),
      ),
    );
  }
  void _openInfoDialog(MainTask task, var taskTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText('$taskTitle',
            style: const TextStyle(
                fontSize: 18
            ),),
          content: SelectableText(
              'Task ID: ${task.taskId}\n\nAssign To: ${task.assignTo}\n\nTask Description: ${task.task_description}'), // Customize the content as needed
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

    const url = "http://dev.workspace.cbs.lk/mainTaskListSecretarial.php";
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
        mainTaskList.sort((a, b) =>
            b.taskCreatedTimestamp.compareTo(a.taskCreatedTimestamp));

        // Count tasks with taskStatus = 0
        int pendingTaskCount = mainTaskList.where((task) => task.taskStatus == "0").length;
        int inProgressTaskCount = mainTaskList.where((task) => task.taskStatus == "1").length;
        int allTaskCount = mainTaskList.length;
        print("Pending Task: $pendingTaskCount");
        print("All Task: $allTaskCount");
        print("In Progress Task: $inProgressTaskCount");
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}
