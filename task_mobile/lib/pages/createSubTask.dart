import 'dart:convert';
import 'dart:math';

import 'package:Workspace_Lite/pages/subTaskList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../components/test.dart';
import '../createAccountPopUps/assignToPopUp.dart';
import '../createAccountPopUps/beneficiaryPopUp.dart';
import '../createAccountPopUps/categoryPopUp.dart';
import '../createAccountPopUps/priorityPopUp.dart';
import '../createAccountPopUps/sourceFromPopUp.dart';
import '../methods/colors.dart';
import '../methods/sizes.dart';
import 'createMainTask.dart';
import 'openTask.dart';

class CreateSubTask extends StatefulWidget {
  final String username;
  final String userRole;
  final String firstName;
  final String lastName;
  final String mainTaskId;
  final MainTask task;

  const CreateSubTask(
      {Key? key,
      required this.username,
      required this.userRole,
      required this.firstName,
      required this.lastName,
      required this.mainTaskId,
      required this.task})
      : super(key: key);

  @override
  State<CreateSubTask> createState() => _CreateSubTaskState();
}

class _CreateSubTaskState extends State<CreateSubTask> {
  String getCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getCurrentMonth() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM').format(now);
    return formattedDate;
  }

  String generatedSubTaskId() {
    final random = Random();
    int min = 1; // Smallest 9-digit number
    int max = 999999999; // Largest 9-digit number
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber.toString().padLeft(9, '0');
  }

  TextEditingController subTaskTitleController = TextEditingController();
  TextEditingController subTaskDescriptionController = TextEditingController();

  Future<void> createSubTask(
    BuildContext context, {
    required subTaskBeneficiary,
    required subTaskPriority,
    required subTaskDueDate,
    required subTaskSourceFrom,
    required subTaskAssignTo,
    required subTaskCategoryName,
    required subTaskCategory,
    required subTaskCreateBy,
  }) async {
    // Validate input fields
    if (subTaskTitleController.text.trim().isEmpty ||
        subTaskDescriptionController.text.isEmpty) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/subTaskCreate.php";

    String firstLetterFirstName =
        widget.firstName.isNotEmpty ? widget.firstName[0] : '';
    String firstLetterLastName =
        widget.lastName.isNotEmpty ? widget.lastName[0] : '';
    String geCategory =
        subTaskCategoryName.substring(subTaskCategoryName.length - 3);
    String taskID = getCurrentMonth() +
        firstLetterFirstName +
        firstLetterLastName +
        geCategory +
        generatedSubTaskId();

    var data = {
      "main_task_id": widget.mainTaskId,
      "task_id": taskID,
      "task_title": subTaskTitleController.text,
      "task_type": '0',
      "task_type_name": subTaskPriority,
      "due_date": subTaskDueDate,
      "task_description": subTaskDescriptionController.text,
      "task_create_by_id": widget.username,
      "task_create_by": subTaskCreateBy, //'${widget.firstName} ${widget.lastName}',
      "task_create_date": getCurrentDate(),
      "task_create_month": getCurrentMonth(),
      "task_created_timestamp": getCurrentDateTime(),
      "task_status": "0",
      "task_status_name": "Pending",
      "task_reopen_by": "",
      "task_reopen_by_id": "",
      "task_reopen_date": "",
      "task_reopen_timestamp": "0",
      "task_finished_by": "",
      "task_finished_by_id": "",
      "task_finished_by_date": "",
      "task_finished_by_timestamp": "0",
      "task_edit_by": "",
      "task_edit_by_id": "",
      "task_edit_by_date": "",
      "task_edit_by_timestamp": "0",
      "task_delete_by": "",
      "task_delete_by_id": "",
      "task_delete_by_date": "",
      "task_delete_by_timestamp": "0",
      "source_from": subTaskSourceFrom,
      "assign_to": subTaskAssignTo,
      "company": subTaskBeneficiary,
      "document_number": '',
      "watch_list": '0',
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0",
      "category_name": subTaskCategoryName,
      "category": subTaskCategory,
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        if (!mounted) return;
        showSuccessSnackBar(context); // Show the success SnackBar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OpenTaskPage(task: widget.task, userRoleForDelete:  widget.userRole, userName: widget.username,
            firstName: widget.firstName,
            lastName:  widget.lastName,)),
        );
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.yellow);
    }
  }

  void showSuccessSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Sub Task Created Successfully'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    String subTaskBeneficiary = '';
    String subTaskDueDate = '';
    String subTaskAssignToValue = ''; // Define assignToValue in the outer scope
    String subTaskPriorityValue = ''; // Define priorityValue in the outer scope
    String subTaskSourceFromValue =
        ''; // Define sourceFromValue in the outer scope
    String subTaskCategoryValue = '';
    String subTaskCategoryInt = '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Sub Task',
          style: TextStyle(
            color: AppColor.tealLog,
            fontSize: 20,
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
            Container(
              color: Colors.white,
              width: getPageWidth(context),
              height: 640,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: subTaskTitleController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Title',
                                hintText: 'Task Title',
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: subTaskDescriptionController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Description',
                                hintText: 'Description',
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 400,
                          width: 500,
                          color: Colors.grey.shade300,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 12, bottom: 20),
                                      child: Text(
                                        'Beneficiary',
                                        style: TextStyle(
                                          fontSize:
                                              14, // Updated font size to 14
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 12, bottom: 20),
                                      child: Text(
                                        'Due Date',
                                        style: TextStyle(
                                          fontSize:
                                              14, // Updated font size to 14
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 12, bottom: 20),
                                      child: Text(
                                        'Assign To',
                                        style: TextStyle(
                                          fontSize:
                                              14, // Updated font size to 14
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 12, bottom: 20),
                                      child: Text(
                                        'Priority',
                                        style: TextStyle(
                                          fontSize:
                                              14, // Updated font size to 14
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 12, bottom: 20),
                                      child: Text(
                                        'Source From', // Updated text here
                                        style: TextStyle(
                                          fontSize:
                                              14, // Updated font size to 14
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 12, bottom: 20),
                                      child: Text(
                                        'Task Category',
                                        style: TextStyle(
                                          fontSize:
                                              14, // Updated font size to 14
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<BeneficiaryState>(
                                    builder:
                                        (context, beneficiaryState, child) {
                                      subTaskBeneficiary = beneficiaryState
                                              .value ??
                                          'DefaultBeneficiary'; // Set beneficiaryValue based on state

                                      return TextButton(
                                        onPressed: () {
                                          beneficiaryPopupMenu(
                                              context, beneficiaryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskBeneficiary,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<DueDateState>(
                                    builder: (context, dueDateState, child) {
                                      subTaskDueDate =
                                          dueDateState.selectedDate != null
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  dueDateState.selectedDate!)
                                              : 'Due date';

                                      return TextButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2023),
                                            lastDate: DateTime(2030),
                                          ).then((pickedDate) {
                                            if (pickedDate != null) {
                                              dueDateState.selectedDate =
                                                  pickedDate;
                                              print(dueDateState.selectedDate);
                                            }
                                          });
                                          // Your logic for dueDate popup menu
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskDueDate,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<AssignToState>(
                                    builder: (context, assignToState, child) {
                                      subTaskAssignToValue =
                                          assignToState.value ?? 'Assign To';

                                      return TextButton(
                                        onPressed: () {
                                          assignToPopupMenu(
                                              context, assignToState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskAssignToValue,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<PriorityState>(
                                    builder: (context, priorityState, child) {
                                      subTaskPriorityValue =
                                          priorityState.value ?? 'Priority';

                                      return TextButton(
                                        onPressed: () {
                                          priorityPopupMenu(
                                              context, priorityState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskPriorityValue,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<SourceFromState>(
                                    builder: (context, sourceFromState, child) {
                                      subTaskSourceFromValue =
                                          sourceFromState.value ??
                                              'Source From';

                                      return TextButton(
                                        onPressed: () {
                                          sourceFromPopupMenu(
                                              context, sourceFromState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskSourceFromValue,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<CategoryState>(
                                    builder: (context, categoryState, child) {
                                      subTaskCategoryValue =
                                          categoryState.value ?? 'Category';
                                      subTaskCategoryInt = categoryState
                                          .selectedIndex
                                          .toString();

                                      return TextButton(
                                        onPressed: () {
                                          categoryPopupMenu(
                                              context, categoryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskCategoryValue,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 140,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        createSubTask(
                          context,
                          subTaskBeneficiary: subTaskBeneficiary,
                          subTaskPriority: subTaskPriorityValue,
                          subTaskDueDate: subTaskDueDate,
                          subTaskSourceFrom: subTaskSourceFromValue,
                          subTaskAssignTo: subTaskAssignToValue,
                          subTaskCategoryName: subTaskCategoryValue,
                          subTaskCategory: subTaskCategoryInt,
                          subTaskCreateBy:
                              '${widget.firstName} ${widget.lastName}',
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.loginF,
                        backgroundColor: Colors.lightBlue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 140,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.loginF,
                        backgroundColor: Colors.lightBlue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
