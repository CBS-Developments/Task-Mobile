import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/taskMainPages/auditMain.dart';
import 'package:task_mobile/taskMainPages/companySecretarialMain.dart';
import 'package:task_mobile/taskMainPages/developmentMain.dart';
import 'package:task_mobile/taskMainPages/financeMain.dart';
import 'package:task_mobile/taskMainPages/AllmainTaskList.dart';
import 'package:task_mobile/pages/subTaskList.dart';
import 'package:task_mobile/taskMainPages/talentMain.dart';
import 'package:task_mobile/taskMainPages/taxationMain.dart';

import '../components/test.dart';
import '../methods/colors.dart';
import 'addComment.dart';
import 'createSubTask.dart';
import 'package:http/http.dart' as http;

import 'editMainTask.dart';

class OpenTaskPage extends StatefulWidget {
  final String userRoleForDelete;
  final String userName;
  final String firstName;
  final String lastName;
  final MainTask task;

  const OpenTaskPage(
      {Key? key,
      required this.userRoleForDelete,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.task})
      : super(key: key);

  @override
  State<OpenTaskPage> createState() => _OpenTaskPageState();
}

class _OpenTaskPageState extends State<OpenTaskPage> {

  String userName = '';

  String firstName = '';
  String lastName = '';
  String userRole = '';
  // List<comment> commentList = []; // Initialize subtask list
  TextEditingController mainTaskCommentController = TextEditingController();
  List<comment> comments = [];

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

  Future<void> retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
    print('User Name: $userName');
  }

  void showDeleteConfirmationDialog(
      BuildContext context,
      String userRole,
      String taskId,
      ) {
    print('User Role in showDeleteConfirmationDialog: $userRole');
    if (userRole == '1') {
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteMainTask(taskId); // Call the deleteMainTask method
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or take other actions for users who are not admins
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Only admins are allowed to delete tasks.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> deleteMainTask(
      String taskID,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '99',
      "task_status_name": 'Deleted',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteMainTask.php";

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
          snackBar(context, "Main Task Deleted successful!", Colors.redAccent);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return MainTaskList();
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

  Future<bool> markInProgressMainTask(
      String taskID,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '1',
      "task_status_name": 'In Progress',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteMainTask.php";

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
          // Handle success and navigation based on the category.
          handleCategoryNavigation();
          snackBar(
              context, "Main Marked as In Progress successful!", Colors.green);

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

  Future<bool> markAsCompletedMainTask(
      String taskID,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '2',
      "task_status_name": 'Completed',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteMainTask.php";

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
          // Handle success and navigation based on the category.
          handleCategoryNavigation();
          snackBar(context, "Main Marked Completed successful!", Colors.green);

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
  void handleCategoryNavigation() {
    switch (widget.task.category) {
      case "0":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxationMainTask()));
        break;
      case "1":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TalentMain()));
        break;
      case "2":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FinanceMain()));
        break;
      case "3":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AuditMain()));
        break;
      case "4":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SecretarialMain()));
        break;
      case "5":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DevelopmentMain()));
        break;
      default:
        snackBar(context, "Unknown Category", Colors.red);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainTaskList()));
        break;
    }
  }



  Future<List<comment>> getCommentList(String taskId) async {
    comments
        .clear(); // Assuming that `comments` is a List<Comment> in your class

    var data = {
      "task_id": taskId,
    };

    const url = "http://dev.workspace.cbs.lk/commentListById.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return jsonResponse.map((sec) => comment.fromJson(sec)).toList();
      }

      return [];
    } else {
      throw Exception(
          'Failed to load data from the API. Status Code: ${response.statusCode}');
    }
  }

  Future<bool> createMainTaskComment(
      BuildContext context, {
        required userName,
        required taskID,
        required firstName,
        required lastName,
      }) async {
    // Validate input fields
    if (mainTaskCommentController.text.trim().isEmpty) {
      // Show an error message if the combined fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/createComment.php";

    var data = {
      "comment_id": getCurrentDateTime(),
      "task_id": taskID,
      "comment": mainTaskCommentController.text,
      "comment_create_by_id": userName,
      "comment_create_by": firstName + ' ' + lastName,
      "comment_create_date": getCurrentDate(),
      "comment_created_timestamp": getCurrentDateTime(),
      "comment_status": "1",
      "comment_edit_by": "",
      "comment_edit_by_id": '',
      "comment_edit_by_date": "",
      "comment_edit_by_timestamp": "",
      "comment_delete_by": "",
      "comment_delete_by_id": "",
      "comment_delete_by_date": "",
      "comment_delete_by_timestamp": "",
      "comment_attachment": '',
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
        if (!mounted) return true;
        mainTaskCommentController.clear();
        snackBar(context, "Comment Added Successfully", Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenTaskPage(
                task: widget.task,
                userRoleForDelete: widget.userRoleForDelete,
                userName: widget.userName,
                firstName: widget.firstName,
                lastName: widget.lastName,
              )),
        );
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  void showDeleteCommentConfirmation(
      BuildContext context,
      String commentID,
      String createBy,
      String nameNowUser,
      ) {
    print('Now user: $nameNowUser');
    if (createBy == nameNowUser) {
      print(createBy);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this Comment?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteComment(commentID);
                  // deleteMainTask(taskId); // Call the deleteMainTask method
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or take other actions for users who are not admins
      print(createBy);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Only your comments allowed to delete.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> deleteComment(
      String commentId,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "comment_id": commentId,
      "comment_delete_by": widget.userName,
      "comment_delete_by_id": widget.firstName,
      "comment_delete_by_date": getCurrentDate(),
      "comment_delete_by_timestamp": getCurrentDateTime(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteComment.php";

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
          snackBar(context, "Comment Deleted successful!", Colors.redAccent);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpenTaskPage(
                  task: widget.task,
                  userRoleForDelete: widget.userRoleForDelete,
                  userName: widget.userName,
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                )),
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

  void showSuccessSnackBar(BuildContext context) {
    final snackBar = const SnackBar(
      content: Text('Comment Added Successfully'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    retrieverData();

    setState(() {
      print("Done");
      getCommentList(widget.task.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  SelectableText(
          widget.task.taskTitle,
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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                        children: [
                          SelectableText(
                            widget.task.taskId,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 35,),
                          Row(
                            children: [
                              IconButton(onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('main_task_id', widget.task.taskId);
                                prefs.setString('main_task_title', widget.task.taskTitle);
                                prefs.setString('intent_from', "main_dashboard");
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  SubTaskList(mainTaskId: widget.task.taskId, task: widget.task, userRoleForDelete: widget.userRoleForDelete,)),
                                );
                              },
                                icon: const Icon(Icons.account_tree_rounded, color: Colors.black, size: 20),),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             EditMainTask(
                                              currentTitle:
                                              widget.task.taskTitle,
                                              currentDescription: widget
                                                  .task.task_description,
                                              currentBeneficiary:
                                              widget.task.company,
                                              currentDueDate:
                                              widget.task.dueDate,
                                              currentAssignTo:
                                              widget.task.assignTo,
                                              currentPriority:
                                              widget.task.taskTypeName,
                                              currentSourceFrom:
                                              widget.task.sourceFrom,
                                              currentCategory:
                                              widget.task.category_name,
                                              taskID: widget.task.taskId,
                                              userName: userName,
                                              firstName: firstName,

                                            )),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDeleteConfirmationDialog(
                                      context,
                                      widget.userRoleForDelete,
                                      widget.task.taskId);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 380,
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
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 2,
                                              right: 4),
                                          child: Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.tealLog,),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: AppColor.tealLog,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 2,
                                              right: 4),
                                          child: Text(
                                            'Due',
                                            style: TextStyle(
                                                fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.tealLog,),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8,   top: 4,),
                                      child: Text(
                                        'Company',
                                        style: TextStyle(
                                            fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4,),
                                      child: Text(
                                        'Assign To',
                                        style: TextStyle(
                                            fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4,),
                                      child: Text(
                                        'Priority',
                                        style: TextStyle(
                                            fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4,),
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4,),
                                      child: Text(
                                        'Created By',
                                        style: TextStyle(
                                            fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.tealLog,),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 328,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            widget.task.taskCreateDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            widget.task.dueDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4),
                                      child: Text(
                                        widget.task.company,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4),
                                      child: Text(
                                        widget.task.assignTo,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4),
                                      child: Text(
                                        widget.task.taskTypeName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4),
                                      child: Text(
                                        widget.task.taskStatusName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8, top: 4),
                                      child: Text(
                                        widget.task.taskCreateBy,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (widget.task.taskStatus == '0') {
                              markInProgressMainTask(widget.task.taskId);
                              // Handle 'Mark In Progress' action
                            } else if (widget.task.taskStatus == '1') {
                              markAsCompletedMainTask(widget.task.taskId);
                              // Handle 'Mark As Complete' action
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.task.taskStatus == '0'
                                  ? 'Mark In Progress'
                                  : 'Mark As Complete',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.task.taskStatus == '0'
                                    ? Colors.blueAccent
                                    : Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateSubTask(
                                    username: widget.userName,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    mainTaskId: widget.task.taskId,
                                    task: widget.task,
                                    userRole: widget.userRoleForDelete,
                                  ),
                                ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Create Sub Task',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommentsPage(
                  userName: widget.userName,
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  userRoleForDelete: widget.userRoleForDelete,
                  task: widget.task,

              )
            ),
          );
        },
        backgroundColor: Colors.teal, // Use the actual color, e.g., Colors.teal
        child: const Icon(Icons.comment),
      ),


    );
  }
}
