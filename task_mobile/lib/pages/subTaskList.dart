import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/pages/createSubTask.dart';
import 'package:task_mobile/pages/openSubTask.dart';

class SubTaskList extends StatefulWidget {
  final String mainTaskId;
  final MainTask task;
  final String userRoleForDelete;

  const SubTaskList({Key? key, required this.mainTaskId, required this.task, required this.userRoleForDelete})
      : super(key: key);

  @override
  State<SubTaskList> createState() => _SubTaskListState();
}

class _SubTaskListState extends State<SubTaskList> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  List<Task> subTaskList = []; // Initialize subtask list

  @override
  void initState() {
    super.initState();
    //print('mainTaskId passed: ${widget.mainTaskId}');
    loadDataAndFetchSubTasks();
  }

  Future<void> loadDataAndFetchSubTasks() async {
    await loadData(); // Wait for loadData to complete
    await getSubTaskListByMainTaskId(
        widget.mainTaskId); // Wait for data retrieval
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";
    });
    //print('User Role: $userRole');
  }

  Future<void> getSubTaskListByMainTaskId(String mainTaskId) async {
    subTaskList.clear();
    var data = {
      "main_task_id": mainTaskId,
    };

    const url = "http://dev.workspace.cbs.lk/subTaskListByMainTaskId.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body);
      setState(() {
        for (Map<String, dynamic> details
            in responseJson.cast<Map<String, dynamic>>()) {
          subTaskList.add(Task.fromJson(details));
        }

        subTaskList.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      });
      // print("SubTaskList: $subTaskList");
    } else {
      throw Exception('Failed to load subtasks from API');
    }
  }

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: subTaskList.length,
              itemBuilder: (context, index) {
                Task subTask = subTaskList[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenSubTaskPage(
                                    task: subTask,
                                    userRoleForDelete: userRole,
                                    userName: userName,
                                    firstName: firstName,
                                    lastName: lastName,
                                  )));
                        },
                        child: Text(
                          subTask.taskTitle,
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
                          subTask.dueDate,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // Add a new button to open a dialog
                    //     // IconButton(
                    //     //   icon: const Icon(Icons.menu_open_rounded,
                    //     //       color: Colors.teal),
                    //     //   onPressed: () {
                    //     //     // Open subtask details here
                    //     //     // Navigator.push(
                    //     //     //   context,
                    //     //     //   MaterialPageRoute(
                    //     //     //     builder: (context) => OpenSubTaskNew(
                    //     //     //       task: subTask,
                    //     //     //       userRoleForDelete: userRole,
                    //     //     //       userName: userName,
                    //     //     //       firstName: firstName,
                    //     //     //       lastName: lastName,
                    //     //     //     ),
                    //     //     //   ),
                    //     //     // );
                    //     //   },
                    //     // ),
                    //   ],
                    // ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSubTask(
                username: userName,
                firstName: firstName,
                lastName: lastName,
                mainTaskId: widget.task.taskId,
                task: widget.task,
                userRole: widget.userRoleForDelete,
              ),
            ),
          );
        },
        backgroundColor: Colors.teal, // Use the actual color, e.g., Colors.teal
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Task {
  String taskId;
  String taskTitle;
  String taskType;
  String dueDate;
  String taskTypeName;
  String taskDescription;
  String taskCreateById;
  String taskCreateBy;
  String taskCreateDate;
  String taskCreateMonth;
  String taskCreatedTimestamp;
  String taskStatus;
  String taskStatusName;
  String actionTakenById;
  String actionTakenBy;
  String actionTakenDate;
  String actionTakenTimestamp;
  String taskReopenBy;
  String taskReopenById;
  String taskReopenDate;
  String taskReopenTimestamp;
  String taskFinishedBy;
  String taskFinishedById;
  String taskFinishedByDate;
  String taskFinishedByTimestamp;
  String taskEditBy;
  String taskEditById;
  String taskEditByDate;
  String taskEditByTimestamp;
  String taskDeleteBy;
  String taskDeleteById;
  String taskDeleteByDate;
  String taskDeleteByTimestamp;
  String sourceFrom;
  String assignTo;
  String company;
  String documentNumber;
  String watchList;
  String categoryName;
  String category;

  Task({
    required this.taskId,
    required this.taskTitle,
    required this.taskType,
    required this.dueDate,
    required this.taskTypeName,
    required this.taskDescription,
    required this.taskCreateById,
    required this.taskCreateBy,
    required this.taskCreateDate,
    required this.taskCreateMonth,
    required this.taskCreatedTimestamp,
    required this.taskStatus,
    required this.taskStatusName,
    required this.actionTakenById,
    required this.actionTakenBy,
    required this.actionTakenDate,
    required this.actionTakenTimestamp,
    required this.taskReopenBy,
    required this.taskReopenById,
    required this.taskReopenDate,
    required this.taskReopenTimestamp,
    required this.taskFinishedBy,
    required this.taskFinishedById,
    required this.taskFinishedByDate,
    required this.taskFinishedByTimestamp,
    required this.taskEditBy,
    required this.taskEditById,
    required this.taskEditByDate,
    required this.taskEditByTimestamp,
    required this.taskDeleteBy,
    required this.taskDeleteById,
    required this.taskDeleteByDate,
    required this.taskDeleteByTimestamp,
    required this.sourceFrom,
    required this.assignTo,
    required this.company,
    required this.documentNumber,
    required this.watchList,
    required this.categoryName,
    required this.category,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        taskId: json['task_id'],
        taskTitle: json['task_title'],
        taskType: json['task_type'],
        dueDate: json['due_date'],
        taskTypeName: json['task_type_name'],
        taskDescription: json['task_description'],
        taskCreateById: json['task_create_by_id'],
        taskCreateBy: json['task_create_by'],
        taskCreateDate: json['task_create_date'],
        taskCreateMonth: json['task_create_month'],
        taskCreatedTimestamp: json['task_created_timestamp'],
        taskStatus: json['task_status'],
        taskStatusName: json['task_status_name'],
        actionTakenById: json['action_taken_by_id'],
        actionTakenBy: json['action_taken_by'],
        actionTakenDate: json['action_taken_date'],
        actionTakenTimestamp: json['action_taken_timestamp'],
        taskReopenBy: json['task_reopen_by'],
        taskReopenById: json['task_reopen_by_id'],
        taskReopenDate: json['task_reopen_date'],
        taskReopenTimestamp: json['task_reopen_timestamp'],
        taskFinishedBy: json['task_finished_by'],
        taskFinishedById: json['task_finished_by_id'],
        taskFinishedByDate: json['task_finished_by_date'],
        taskFinishedByTimestamp: json['task_finished_by_timestamp'],
        taskEditBy: json['task_edit_by'],
        taskEditById: json['task_edit_by_id'],
        taskEditByDate: json['task_edit_by_date'],
        taskEditByTimestamp: json['task_edit_by_timestamp'],
        taskDeleteBy: json['task_delete_by'],
        taskDeleteById: json['task_delete_by_id'],
        taskDeleteByDate: json['task_delete_by_date'],
        taskDeleteByTimestamp: json['task_delete_by_timestamp'],
        sourceFrom: json['source_from'],
        assignTo: json['assign_to'],
        company: json['company'],
        documentNumber: json['document_number'],
        watchList: json['watch_list'],
        categoryName: json['category_name'],
        category: json['category']);
  }
}
