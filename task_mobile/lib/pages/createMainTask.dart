import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Workspace_Lite/methods/colors.dart';
import 'package:Workspace_Lite/taskMainPages/AllmainTaskList.dart';

import '../components/test.dart';
import 'package:http/http.dart' as http;

import '../createAccountPopUps/assignToPopUp.dart';
import '../createAccountPopUps/beneficiaryPopUp.dart';
import '../createAccountPopUps/categoryPopUp.dart';
import '../createAccountPopUps/priorityPopUp.dart';
import '../createAccountPopUps/sourceFromPopUp.dart';
import '../methods/sizes.dart';

class CreateMainTask extends StatefulWidget {
  final String username;
  final String firstName;
  final String lastName;

  const CreateMainTask(
      {Key? key,
      required this.username,
      required this.firstName,
      required this.lastName})
      : super(key: key);

  @override
  State<CreateMainTask> createState() => _CreateMainTaskState();
}

class _CreateMainTaskState extends State<CreateMainTask> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

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
    final formattedDate = DateFormat('yy-MM').format(now);
    return formattedDate;
  }

  String generatedTaskId() {
    final random = Random();
    int min = 1; // Smallest 9-digit number
    int max = 999999999; // Largest 9-digit number
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber.toString().padLeft(9, '0');
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> createMainTask(
    BuildContext context, {
    required beneficiary,
    required priority,
    required due_date,
    required sourceFrom,
    required assignTo,
    required categoryName,
    required category,
    required createBy,
  }) async {
    // Validate input fields
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.isEmpty) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/mainTaskCreate.php";

    String firstLetterFirstName =
        widget.firstName.isNotEmpty ? widget.firstName[0] : '';
    String firstLetterLastName =
        widget.lastName.isNotEmpty ? widget.lastName[0] : '';
    String geCategory = categoryName.substring(categoryName.length - 3);
    String taskID = getCurrentMonth() +
        firstLetterFirstName +
        firstLetterLastName +
        geCategory +
        generatedTaskId();

    var data = {
      "task_id": taskID,
      "task_title": titleController.text,
      "task_type": '0',
      "task_type_name": priority,
      "due_date": due_date,
      "task_description": descriptionController.text,
      "task_create_by_id": widget.username,
      "task_create_by": createBy,
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
      "source_from": sourceFrom,
      "assign_to": assignTo,
      "company": beneficiary,
      "document_number": '',
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0",
      "category_name": categoryName,
      "category": category,
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
          MaterialPageRoute(builder: (context) => MainTaskList()),
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
    final snackBar = const SnackBar(
      content: Text('Main Task Created Successfully'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != controller.text) {
      print('Selected date: $picked'); // Add this line for debugging
      controller.text = DateFormat('yyyy-MM-dd')
          .format(picked); // Adjust the date format as needed
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String beneficiary = '';
    String dueDate = '';
    String assignToValue = '';
    String priorityValue = '';
    String sourceFromValue = '';
    String categoryValue = '';
    String categoryInt = '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Main Task',
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
                              controller: titleController,
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
                              controller: descriptionController,
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
                                      beneficiary = beneficiaryState.value ??
                                          'DefaultBeneficiary'; // Set beneficiaryValue based on state

                                      return TextButton(
                                        onPressed: () {
                                          beneficiaryPopupMenu(
                                              context, beneficiaryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              beneficiary,
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
                                      dueDate =
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
                                              dueDate,
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
                                      assignToValue =
                                          assignToState.value ?? 'Assign To';

                                      return TextButton(
                                        onPressed: () {
                                          assignToPopupMenu(
                                              context, assignToState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              assignToValue,
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
                                      priorityValue =
                                          priorityState.value ?? 'Priority';

                                      return TextButton(
                                        onPressed: () {
                                          priorityPopupMenu(
                                              context, priorityState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              priorityValue,
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
                                      sourceFromValue = sourceFromState.value ??
                                          'Source From';

                                      return TextButton(
                                        onPressed: () {
                                          sourceFromPopupMenu(
                                              context, sourceFromState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              sourceFromValue,
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
                                      categoryValue =
                                          categoryState.value ?? 'Category';
                                      categoryInt = categoryState.selectedIndex
                                          .toString();

                                      return TextButton(
                                        onPressed: () {
                                          categoryPopupMenu(
                                              context, categoryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              categoryValue,
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
            SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        height: 40,
                        width: 140,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            createMainTask(context,
                                beneficiary: beneficiary,
                                priority: priorityValue,
                                due_date: dueDate,
                                sourceFrom: sourceFromValue,
                                assignTo: assignToValue,
                                categoryName: categoryValue,
                                category: categoryInt,
                                createBy: '${widget.firstName} ${widget.lastName}');
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DueDateState extends ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
