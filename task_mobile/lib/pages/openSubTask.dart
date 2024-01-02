import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Workspace_Lite/pages/subTaskComment.dart';
import 'package:Workspace_Lite/pages/subTaskList.dart';
import 'package:Workspace_Lite/taskMainPages/talentMain.dart';
import 'package:Workspace_Lite/taskMainPages/taxationMain.dart';

import '../components/test.dart';
import '../methods/colors.dart';
import '../taskMainPages/AllmainTaskList.dart';
import '../taskMainPages/auditMain.dart';
import '../taskMainPages/companySecretarialMain.dart';
import 'createSubTask.dart';
import '../taskMainPages/developmentMain.dart';
import 'editSubTask.dart';
import '../taskMainPages/financeMain.dart';

class OpenSubTaskPage extends StatefulWidget {
  final String userRoleForDelete;
  final String userName;
  final String firstName;
  final String lastName;
  final Task task;
  final MainTask mainTaskDetails;

  const OpenSubTaskPage({Key? key, required this.userRoleForDelete, required this.userName, required this.firstName, required this.lastName, required this.task, required this.mainTaskDetails}) : super(key: key);

  @override
  State<OpenSubTaskPage> createState() => _OpenSubTaskPageState();
}

class _OpenSubTaskPageState extends State<OpenSubTaskPage> {
  String userName = '';
  String firstName = '';
  String lastName = '';
  String userRole = '';
  List<comment> comments = [];
  TextEditingController subTaskCommentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }

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

  void showDeleteConfirmationDialog(
      BuildContext context,
      String userRole,
      String taskId,
      ) {
    print('User Role in showDeleteConfirmationDialog Sub: $userRole');
    if (userRole == '1') {
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this task?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteSubTask(taskId);
                  // Call the deleteMainTask method// Close the dialog
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
            title: Text('Permission Denied'),
            content: Text('Only admins are allowed to delete tasks.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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


  Future<bool> deleteSubTask(
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
    const url = "http://dev.workspace.cbs.lk/deleteSubTask.php";

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
          snackBar(context, "Sub Task Deleted successful!", Colors.redAccent);
          // Handle success and navigation based on the category.
          handleCategoryNavigation();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return const TaskMainPage();
          //   }),
          // );
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

  Future<bool> markInProgressSubTask(
      String taskName,
      String userName,
      String firstName,
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
    const url = "http://dev.workspace.cbs.lk/deleteSubTask.php";

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
          addLogStatus(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName);
         snackBar(context, "Sub Task Marked as In Progress!", Colors.blueAccent);
          // Handle success and navigation based on the category.
          handleCategoryNavigation();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return const TaskMainPage();
          //   }),
          // );
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

  Future<bool> completeSubTask(
      String taskName,
      String userName,
      String firstName,
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
    const url = "http://dev.workspace.cbs.lk/deleteSubTask.php";

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
          addLogStatusComplete(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName);
          snackBar(context, "Sub Task Marked As Complete", Colors.green);

          // Handle success and navigation based on the category.
          handleCategoryNavigation();

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return const TaskMainPage();
          //   }),
          // );
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



  Future<bool> createMainTaskComment(
      BuildContext context, {
        required userName,
        required taskID,
        required firstName,
        required lastName,
      }) async {
    // Validate input fields
    if (subTaskCommentController.text.trim().isEmpty) {
      // Show an error message if the combined fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/createComment.php";

    var data = {
      "comment_id": getCurrentDateTime(),
      "task_id": taskID,
      "comment": subTaskCommentController.text,
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
        subTaskCommentController.clear();
        snackBar(context, "Comment Added Successfully", Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenSubTaskPage(
                  task: widget.task,
                  userRoleForDelete: widget.userRoleForDelete,
                  userName: widget.userName,
                  firstName: widget.firstName,
                  lastName: widget.lastName, mainTaskDetails: widget.mainTaskDetails,)),
        );
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
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


  Future<void> addLog(
      BuildContext context, {
        required taskId,
        required taskName,
        required createBy,
        required createByID,
      }) async {
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/addLog.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": 'Commented to Main Task',
      "log_type": 'Commented',
      "log_create_by": createBy,
      "log_create_by_id": createByID,
      "log_create_by_date": getCurrentDate(),
      "log_create_by_month": getCurrentMonth(),
      "log_create_by_year": '',
      "log_created_by_timestamp": getCurrentDateTime(),
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
        print('Log added!!');
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
  }

  Future<void> addLogStatus(
      BuildContext context, {
        required taskId,
        required taskName,
        required createBy,
        required createByID,
      }) async {
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/addLog.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": 'Mark as In Progress',
      "log_type": 'Status Changed',
      "log_create_by": createBy,
      "log_create_by_id": createByID,
      "log_create_by_date": getCurrentDate(),
      "log_create_by_month": getCurrentMonth(),
      "log_create_by_year": '',
      "log_created_by_timestamp": getCurrentDateTime(),
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
        print('Log added!!');
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
  }

  Future<void> addLogStatusComplete(
      BuildContext context, {
        required taskId,
        required taskName,
        required createBy,
        required createByID,
      }) async {
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/addLog.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": 'Mark as Completed',
      "log_type": 'Status Changed',
      "log_create_by": createBy,
      "log_create_by_id": createByID,
      "log_create_by_date": getCurrentDate(),
      "log_create_by_month": getCurrentMonth(),
      "log_create_by_year": '',
      "log_created_by_timestamp": getCurrentDateTime(),
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
        print('Log added!!');
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
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
            content:
            const Text('Are you sure you want to delete this Comment?'),
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
                builder: (context) => OpenSubTaskPage(
                    task: widget.task,
                    userRoleForDelete: widget.userRoleForDelete,
                    userName: widget.userName,
                    firstName: widget.firstName,
                    lastName: widget.lastName, mainTaskDetails: widget.mainTaskDetails,)),
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
    Task task = widget.task;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText(
                            '${task.taskId}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 80,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditSubTaskPage1(taskID: widget.task.taskId, userName: userName, firstName: firstName, mainTaskDetails: widget.mainTaskDetails, task: task)));
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        'Description: ${task.taskDescription}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
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
                          height: 300,
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
                                              top: 10,
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
                                              top: 10,
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
                                              top: 10,
                                              right: 4),
                                          child: Text(
                                            task.taskCreateDate,
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
                                              top: 10,
                                              right: 4),
                                          child: Text(
                                            task.dueDate,
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
                                        task.company,
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
                                        task.assignTo,
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
                                        task.taskTypeName,
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
                                        task.taskStatusName,
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
                                        task.taskCreateBy,
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
                    SizedBox(
                      width: 480,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (widget.task.taskStatus == '0') {
                                markInProgressSubTask(task.taskTitle,
                                    userName,
                                    firstName,
                                    task.taskId);
                                // Handle 'Mark In Progress' action
                              } else if (widget.task.taskStatus == '1') {
                                completeSubTask( task.taskTitle,
                                    userName,
                                    firstName,
                                    task.taskId);
                                // Handle 'Mark As Complete' action
                              }
                              // Add a condition for 'Completed' here if needed
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.task.taskStatus == '0'
                                    ? 'Mark In Progress'
                                    : widget.task.taskStatus == '1'
                                    ? 'Mark As Complete'
                                    : widget.task.taskStatus == '2'
                                    ? 'Completed'
                                    : 'Unknown Status', // Handle other status values
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.task.taskStatus == '0'
                                      ? Colors.blueAccent
                                      : widget.task.taskStatus == '1'
                                      ? Colors.redAccent
                                      : Colors.green, // Change color for the 'Completed' status
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),


              ),

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubTaskComment(
                  userName: widget.userName,
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  userRoleForDelete: widget.userRoleForDelete,
                  task: widget.task, mainTaskDetails: widget.mainTaskDetails,

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
