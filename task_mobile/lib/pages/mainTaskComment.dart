import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../components/test.dart';
import 'createSubTask.dart';
import 'openTask.dart';

class CommentsPage extends StatefulWidget {
  final String userRoleForDelete;
  final String userName;
  final String firstName;
  final String lastName;
  final MainTask task;

  const CommentsPage(
      {Key? key,
      required this.userRoleForDelete,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.task})
      : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
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

  String getCurrentMonth() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yy-MM').format(now);
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
    required taskName,
    required firstName,
    required lastName,
    required logType,
    required logSummary,
    required logDetails,
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
        addLog(context,
            taskId: taskID,
            taskName: taskName,
            createBy: firstName,
            createByID: userName,
            logType: logType,
            logSummary: logSummary,
            logDetails: logDetails);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenTaskPage(
                    task: widget.task,
                    userRoleForDelete: widget.userRoleForDelete,
                    userName: widget.userName,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    taskDetails: widget.task,
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
    print('Crate By: $createBy');
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
    String logType = 'Comment';
    String logSummary = 'Deleted';
    String logDetails = '';
    // Prepare the data to be sent to the PHP script.
    var data = {
      "comment_id": commentId,
      "comment_delete_by": userName,
      "comment_delete_by_id":  firstName + ' ' + lastName,
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
          addLog(context, taskId: widget.task.taskId, taskName: widget.task.taskTitle, createBy: widget.firstName, createByID: userName, logType: logType, logSummary: logSummary, logDetails: logDetails);
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
                      taskDetails: widget.task,
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

  Future<void> addLog(
    BuildContext context, {
    required taskId,
    required taskName,
    required createBy,
    required createByID,
    required logType,
    required logSummary,
    required logDetails,
  }) async {
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/addLogUpdate.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": logSummary,
      "log_type": logType,
      "log_details": logDetails,
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
        title: SelectableText(
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
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SelectableText(
                    widget.task.taskId,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              //scrollDirection: Axis.horizontal,
              child: Container(
                width: 460,
                height: 550,
                color: Colors.white,
                child: FutureBuilder<List<comment>>(
                  future: getCommentList(widget.task.taskId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<comment>? data = snapshot.data;
                      return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  title: SelectableText(
                                    data[index].commnt,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            data[index].commentCreatedTimestamp,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '    by: ${data[index].commentCreateBy}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDeleteCommentConfirmation(
                                          context,
                                          data[index].commentId,
                                          data[index].commentCreateBy,
                                          '${widget.firstName} ${widget.lastName}');
                                    },
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.redAccent,
                                      size: 16,
                                    ),
                                  ),
                                  // You can add more ListTile properties as needed
                                ),

                                Divider()
                                // Add dividers or spacing as needed between ListTiles
                                // Example: Adds a divider between ListTiles
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text("-Empty-");
                    }
                    return const Text("Loading...");
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: 460,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mainTaskCommentController,
                        textAlignVertical: TextAlignVertical.bottom,
                        maxLines: 3, // Adjust the number of lines as needed
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          hintText: 'Write a Comment...',
                          helperStyle: TextStyle(
                              color: Colors.grey.shade700, fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                    //const Icon(Icons.attach_file),
                    const SizedBox(width: 5),
                    IconButton(
                      tooltip: 'Add Comment',
                      onPressed: () {
                        createMainTaskComment(context,
                            userName: widget.userName,
                            taskID: widget.task.taskId,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            taskName: widget.task.taskTitle,
                            logType: 'to Main Task',
                            logSummary: 'Commented',
                            logDetails:
                                " Comment: ${mainTaskCommentController.text}");
                        //   getCommentList(widget.task.taskId);
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.green[900],
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
