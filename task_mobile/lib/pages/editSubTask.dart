import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_mobile/pages/taxationMain.dart';
import 'package:http/http.dart' as http;
import '../components/test.dart';
import '../createAccountPopUps/assignToPopUp.dart';
import '../createAccountPopUps/beneficiaryPopUp.dart';
import '../createAccountPopUps/categoryPopUp.dart';
import '../createAccountPopUps/priorityPopUp.dart';
import '../createAccountPopUps/sourceFromPopUp.dart';
import '../methods/colors.dart';
import 'createMainTask.dart';

class EditSubTaskPage extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;
  final String currentBeneficiary;
  final String currentDueDate;
  final String currentAssignTo;
  final String currentPriority;
  final String currentSourceFrom;
  final String currentCategory;
  final String taskID;
  final String userName;
  final String firstName;

  const EditSubTaskPage({Key? key, required this.currentTitle, required this.currentDescription, required this.currentBeneficiary, required this.currentDueDate, required this.currentAssignTo, required this.currentPriority, required this.currentSourceFrom, required this.currentCategory, required this.taskID, required this.userName, required this.firstName}) : super(key: key);

  @override
  State<EditSubTaskPage> createState() => _EditSubTaskPageState();
}

class _EditSubTaskPageState extends State<EditSubTaskPage> {
  TextEditingController newSubTitleController = TextEditingController();
  TextEditingController newSubDescriptionController = TextEditingController();

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

  Future<bool> editSubTask(
      String taskID,
      String taskTitle,
      String taskTypeName,
      String description,
      String userName,
      String firstName,
      String newCompany,
      String dueDate,
      String assignTo,
      String sourceFrom,
      String categoryName,
      String category,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_title": taskTitle,
      "task_type_name": taskTypeName,
      "task_description": description,
      "task_status_name": 'Pending',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDate(),
      "action_taken_timestamp": getCurrentDate(),
      "task_edit_by": userName,
      "task_edit_by_id": firstName,
      "task_edit_by_date": getCurrentDate(),
      "task_edit_by_timestamp": getCurrentDate(),
      "company": newCompany,
      "due_date": dueDate,
      "assign_to": assignTo,
      "source_from": sourceFrom,
      "category_name": categoryName,
      "category": category,
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/editSubTask.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Successful');
          snackBar(context, " Edit Sub Task successful!", Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const TaxationMainTask();
            }),
          );
          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }

  @override
  Widget build(BuildContext context) {
    String newSubBeneficiary = '';
    String newSubDueDate = '';
    String newSubAssignToValue = ''; // Define assignToValue in the outer scope
    String newSubPriorityValue = ''; // Define priorityValue in the outer scope
    String newSubSourceFromValue = ''; // Define sourceFromValue in the outer scope
    String newSubCategoryValue = '';
    String newSubCategoryInt = '';

    return Scaffold(
      appBar: AppBar(
        title: SelectableText(
          widget.currentTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: newSubTitleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: 'Task Title',
                            hintText: widget.currentTitle,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: newSubDescriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: 'Description',
                            hintText: widget.currentDescription,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 700,
                      height: 380,
                      color: Colors.grey.shade300,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 120,
                              height: 300,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      bottom: 7,
                                      top: 8,
                                    ),
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
                                  const SizedBox(
                                      height: 8), // Updated height to 8
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_rounded,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 6,
                                          bottom: 7,
                                          top: 10,
                                        ),
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
                                    ],
                                  ),
                                  const SizedBox(
                                      height: 8), // Updated height to 8
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      bottom: 5,
                                      top: 22,
                                    ),
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
                                  const SizedBox(
                                      height: 8), // Updated height to 8
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      bottom: 5,
                                      top: 22,
                                    ),
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
                                  const SizedBox(
                                      height: 8), // Updated height to 8
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      bottom: 5,
                                      top: 22,
                                    ),
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
                                  const SizedBox(
                                      height: 8), // Updated height to 8
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      bottom: 5,
                                      top: 22,
                                    ),
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
                                  // Add more text fields here
                                ],
                              )),
                          const VerticalDivider(
                            thickness: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.currentBeneficiary,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Consumer<BeneficiaryState>(
                                    builder:
                                        (context, beneficiaryState, child) {
                                      newSubBeneficiary = beneficiaryState
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
                                              newSubBeneficiary,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
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
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.currentDueDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Consumer<DueDateState>(
                                    builder:
                                        (context, dueDateState, child) {
                                      newSubDueDate = dueDateState
                                          .selectedDate !=
                                          null
                                          ? DateFormat('yyyy-MM-dd').format(
                                          dueDateState.selectedDate!)
                                          : 'No due date selected';

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
                                              print(dueDateState
                                                  .selectedDate);
                                            }
                                          });
                                          // Your logic for dueDate popup menu
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              newSubDueDate,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
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
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.currentAssignTo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Consumer<AssignToState>(
                                    builder:
                                        (context, assignToState, child) {
                                      newSubAssignToValue =
                                          assignToState.value ??
                                              'Assign To';

                                      return TextButton(
                                        onPressed: () {
                                          assignToPopupMenu(
                                              context, assignToState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              newSubAssignToValue,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
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
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    widget.currentPriority,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Consumer<PriorityState>(
                                    builder:
                                        (context, priorityState, child) {
                                      newSubPriorityValue =
                                          priorityState.value ?? 'Priority';

                                      return TextButton(
                                        onPressed: () {
                                          priorityPopupMenu(
                                              context, priorityState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              newSubPriorityValue,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
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
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.currentSourceFrom,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Consumer<SourceFromState>(
                                    builder:
                                        (context, sourceFromState, child) {
                                      newSubSourceFromValue =
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
                                              newSubSourceFromValue,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
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
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.currentCategory,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Consumer<CategoryState>(
                                    builder:
                                        (context, categoryState, child) {
                                      newSubCategoryValue =
                                          categoryState.value ?? 'Category';
                                      newSubCategoryInt = categoryState
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
                                              newSubCategoryValue,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
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
                          )
                        ],
                      ),
                    ),

                  ),
                  const SizedBox(
                      height:
                      20), // Add spacing between the form and buttons
                  SizedBox(
                    width: 750,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          width: 140,
                          padding:
                          const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              editSubTask(
                                  widget.taskID,
                                  newSubTitleController.text,
                                  newSubPriorityValue,
                                  newSubDescriptionController.text,
                                  widget.userName,
                                  widget.firstName,
                                  newSubBeneficiary,
                                  newSubDueDate,
                                  newSubAssignToValue,
                                  newSubSourceFromValue,
                                  newSubCategoryValue,
                                  newSubCategoryInt);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.loginF,
                              backgroundColor: Colors.lightBlue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Rounded corners
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 140,
                          padding:
                          const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.loginF,
                              backgroundColor: Colors.lightBlue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Rounded corners
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
          ],
        ),
      ),
    );
  }
}
