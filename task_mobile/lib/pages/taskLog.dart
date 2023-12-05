import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../components/test.dart';
import '../methods/colors.dart';

class TaskLogPage extends StatefulWidget {
  const TaskLogPage({Key? key}) : super(key: key);

  @override
  State<TaskLogPage> createState() => _TaskLogPageState();
}

class _TaskLogPageState extends State<TaskLogPage> {
  List<TaskLog> logList = [];
  List<TaskLog> filteredLogList = []; // Added for filtered logs
  DateTime selectedDate = DateTime.now();
  String selectedUser = '-- Select User --';

  List<String> users = [
    '-- Select User --',
    'All',
    'Deshika',
    'Iqlas',
    'Udari',
    'Shahiru',
    'Dinethri',
    'Damith',
    'Sulakshana',
    'Samadhi',
    'Sanjana',
  ];


  @override
  void initState() {
    super.initState();
    _fetchTodayLogs();
  }

  Future<List<TaskLog>> getLogList(DateTime selectedDate) async {
    var data = {
      'selectedDate': selectedDate.toLocal().toString(),
    };

    const url = "http://dev.workspace.cbs.lk/taskLogList.php";
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
      List<TaskLog> logs = [];
      for (Map<String, dynamic> details in responseJson) {
        logs.add(TaskLog.fromJson(details));
      }
      return logs;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  List<TaskLog> filterTaskLog(List<TaskLog>? data, DateTime selectedDate) {
    final formatter = DateFormat('yyyy-MM-dd');
    final selectedDateStr = formatter.format(selectedDate);

    return data
        ?.where((log) => log.logCreateByDate == selectedDateStr)
        .toList() ??
        [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedUser = '-- Select User --';
      });

      _fetchTodayLogs(); // Fetch logs for the selected date
      _filterLogs(); // Filter logs based on both date and user
    }
  }

  Future<void> _fetchTodayLogs() async {
    List<TaskLog> todayLogs = await getLogList(selectedDate);
    List<TaskLog> filteredLogs = filterTaskLog(todayLogs, selectedDate);

    setState(() {
      logList = filteredLogs;
      filteredLogList = logList; // Initialize filteredLogList with all logs
    });
  }

  // Added to filter logs based on selected user
  void _filterLogs() {
    setState(() {
      if (selectedUser == '-- Select User --') {
        // Show all logs if 'Select User' is selected
        filteredLogList = logList;
      } else {
        // Filter logs based on selected user
        filteredLogList = logList
            .where((log) => log.logCreateBy == selectedUser)
            .toList();
      }

      // Check if 'All' is selected from the dropdown, fetch all logs for the selected date
      if (selectedUser == 'All') {
        filteredLogList = filterTaskLog(logList, selectedDate);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.tealLog,
        title: Center(
          child: Text(
            'Task Log',
            style: TextStyle(
              color: AppColor.tealLog,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     children: [],
          //   ),
          // ),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.tealLog,
                              ),
                              child: Text("Select Date"),
                            ),
                          ],
                        ),
                        Text(
                          "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: selectedUser,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUser = newValue!;
                          });
                          _filterLogs(); // Added to filter logs when dropdown value changes
                        },
                        items: users.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: filteredLogList.isEmpty
                        ? const Center(
                      child: Text(
                        'There is no Log List to show!!',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredLogList.length,
                      itemBuilder: (context, index) {
                        bool isDeleted = filteredLogList[index].logSummary.toLowerCase() == 'deleted';
                        return Card(
                          color: Colors.grey[200],
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                              title: Text(
                                '${filteredLogList[index].logCreateBy} ${filteredLogList[index].logSummary} ${filteredLogList[index].logType} : ${filteredLogList[index].taskName} | ${filteredLogList[index].logDetails} ',
                                style: TextStyle(color: isDeleted ? Colors.red : null),
                              ),
                              subtitle: Text(filteredLogList[index].logId,
                                // style: TextStyle(color: isDeleted ? Colors.red : null),),
                              )
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
