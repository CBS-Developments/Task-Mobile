import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/methods/colors.dart';
import 'package:http/http.dart' as http;
import '../methods/sizes.dart';

class MainTaskList extends StatefulWidget {
  const MainTaskList({Key? key}) : super(key: key);

  @override
  State<MainTaskList> createState() => _MainTaskListState();
}

class _MainTaskListState extends State<MainTaskList> {

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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Taxation',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
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
                ),
                Container(
                  width: 330,
                  height: 120,
                  //color: Colors.red,
                  decoration:  BoxDecoration(
                    color: Colors.grey[300],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white, // Shadow color
                        blurRadius: 2, // Spread radius
                        offset: Offset(0, 2), // Offset in x and y directions
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 320,
                        height: 55,
                        padding: const EdgeInsets.all(4),
                        //color: Colors.redAccent,
                        child: TextField(
                          controller: taskListController,
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              suffixIcon:const Icon(Icons.search,color: Colors.grey,) ,
                              enabledBorder:  OutlineInputBorder(
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
                              hintStyle: TextStyle(color: Colors.grey[500],fontSize: 16
                              )
                          ),

                        ),
                      ),
                      const Divider(),


                    ],
                  ),


                ),
                const SizedBox(
                  height: 10,
                ),

                SingleChildScrollView(
                  child: SizedBox(
                    width: 330,
                    height: 500,
                    //color: Colors.red,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 80,
                              width: 330,
                              decoration: BoxDecoration(
                                //color: Colors.teal, // Background color
                                borderRadius: BorderRadius.circular(4.0), // Optional: Add rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300, // Shadow color
                                    //blurRadius: 2.0, // Spread of the shadow
                                    offset: const Offset(2, 2), // Offset of the shadow
                                  ),
                                ],
                              ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: mainTaskList.map((task) {
                                    return Container(
                                      height: 70,
                                      width: 330,
                                      decoration: BoxDecoration(
                                        //color: Colors.teal,
                                        borderRadius: BorderRadius.circular(8.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2.0,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(task.taskTitle),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Due Date:'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )

                            ),


                          ],
                        ),
                      ],
                    ),
                  ),
                )


              ],
            ),
          ],
        ),
      )
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

class MainTask {
  String taskId;
  String taskTitle;
  String taskType;
  String taskTypeName;
  String dueDate;
  String task_description;
  String taskCreateById;
  String taskCreateBy;
  String taskCreateDate;
  String taskCreateMonth;
  String taskCreatedTimestamp;
  String taskStatus;
  String taskStatusName;
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
  String category_name;
  String category;

  MainTask({
    required this.taskId,
    required this.taskTitle,
    required this.taskType,
    required this.taskTypeName,
    required this.dueDate,
    required this.task_description,
    required this.taskCreateById,
    required this.taskCreateBy,
    required this.taskCreateDate,
    required this.taskCreateMonth,
    required this.taskCreatedTimestamp,
    required this.taskStatus,
    required this.taskStatusName,
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
    required this.category_name,
    required this.category,
  });

  factory MainTask.fromJson(Map<String, dynamic> json) {
    return MainTask(
      taskId: json['task_id'],
      taskTitle: json['task_title'],
      taskType: json['task_type'],
      taskTypeName: json['task_type_name'],
      dueDate: json['due_date'],
      task_description: json['task_description'],
      taskCreateById: json['task_create_by_id'],
      taskCreateBy: json['task_create_by'],
      taskCreateDate: json['task_create_date'],
      taskCreateMonth: json['task_create_month'],
      taskCreatedTimestamp: json['task_created_timestamp'],
      taskStatus: json['task_status'],
      taskStatusName: json['task_status_name'],
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
      category_name: json['category_name'],
      category: json['category'],
    );
  }
}
