import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> snackBar( BuildContext context, String message, Color color) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: color, fontSize: 17.0),
    ),
  ));
}

Future<void> saveRefrance(String key, String value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString(key, value);
}

class taskLog {
  // int id;
  String logId;
  String logSummary;
  String taskId;
  String taskName;
  String logType;
  String logCreateBy;
  String logCreateById;
  String logCreateByDate;
  String logCreateByMonth;
  String logCreateByYear;
  String logCreateByTimestamp;

  taskLog({
    // this.id,
    required this.logId,
    required this.logSummary,
    required this.taskId,
    required this.taskName,
    required this.logType,
    required this.logCreateBy,
    required this.logCreateById,
    required this.logCreateByDate,
    required this.logCreateByMonth,
    required this.logCreateByYear,
    required this.logCreateByTimestamp,
  });

  factory taskLog.fromJson(Map<String, dynamic> json) {
    return taskLog(
      // id: json['id'],
        logId: json['log_id'],
        logSummary: json['log_summary'],
        taskId: json['task_id'],
        taskName: json['task_name'],
        logType: json['log_type'],
        logCreateBy: json['log_create_by'],
        logCreateById: json['log_create_by_id'],
        logCreateByDate: json['log_create_by_date'],
        logCreateByMonth: json['log_create_by_month'],
        logCreateByYear: json['log_create_by_year'],
        logCreateByTimestamp: json['log_create_by_timestamp']);
  }
}


class comment {
  String commentId;
  String taskId;
  String commnt;
  String commentCreateById;
  String commentCreateBy;
  String commentCreateDate;
  String commentCreatedTimestamp;
  String commentStatus;
  String commentEditBy;
  String commentEditById;
  String commentEditByDate;
  String commentEditByTimestamp;
  String commentDeleteBy;
  String commentDeleteById;
  String commentDeleteByDate;
  String commentDeleteByTimestamp;

  comment({
    required this.commentId,
    required this.taskId,
    required this.commnt,
    required this.commentCreateById,
    required this.commentCreateBy,
    required this.commentCreateDate,
    required this.commentCreatedTimestamp,
    required this.commentStatus,
    required this.commentEditBy,
    required this.commentEditById,
    required this.commentEditByDate,
    required this.commentEditByTimestamp,
    required this.commentDeleteBy,
    required this.commentDeleteById,
    required this.commentDeleteByDate,
    required this.commentDeleteByTimestamp,
  });

  factory comment.fromJson(Map<String, dynamic> json) {
    return comment(
        commentId: json['comment_id'],
        taskId: json['task_id'],
        commnt: json['comment'],
        commentCreateById: json['comment_create_by_id'],
        commentCreateBy: json['comment_create_by'],
        commentCreateDate: json['comment_create_date'],
        commentCreatedTimestamp: json['comment_created_timestamp'],
        commentStatus: json['comment_status'],
        commentEditBy: json['comment_edit_by'],
        commentEditById: json['comment_edit_by_id'],
        commentEditByDate: json['comment_edit_by_date'],
        commentEditByTimestamp: json['comment_edit_by_timestamp'],
        commentDeleteBy: json['comment_delete_by'],
        commentDeleteById: json['comment_delete_by_id'],
        commentDeleteByDate: json['comment_delete_by_date'],
        commentDeleteByTimestamp: json['comment_delete_by_timestamp']);
  }
}

// class Task {
//   String taskId;
//   String taskTitle;
//   String taskType;
//   String dueDate;
//   String taskTypeName;
//   String taskDescription;
//   String taskCreateById;
//   String taskCreateBy;
//   String taskCreateDate;
//   String taskCreateMonth;
//   String taskCreatedTimestamp;
//   String taskStatus;
//   String taskStatusName;
//   String actionTakenById;
//   String actionTakenBy;
//   String actionTakenDate;
//   String actionTakenTimestamp;
//   String taskReopenBy;
//   String taskReopenById;
//   String taskReopenDate;
//   String taskReopenTimestamp;
//   String taskFinishedBy;
//   String taskFinishedById;
//   String taskFinishedByDate;
//   String taskFinishedByTimestamp;
//   String taskEditBy;
//   String taskEditById;
//   String taskEditByDate;
//   String taskEditByTimestamp;
//   String taskDeleteBy;
//   String taskDeleteById;
//   String taskDeleteByDate;
//   String taskDeleteByTimestamp;
//   String sourceFrom;
//   String assignTo;
//   String company;
//   String documentNumber;
//
//
//   Task(
//       {required this.taskId,
//         required this.taskTitle,
//         required this.taskType,
//         required this.dueDate,
//         required this.taskTypeName,
//         required this.taskDescription,
//         required this.taskCreateById,
//         required this.taskCreateBy,
//         required this.taskCreateDate,
//         required this.taskCreateMonth,
//         required this.taskCreatedTimestamp,
//         required this.taskStatus,
//         required this.taskStatusName,
//         required this.actionTakenById,
//         required this.actionTakenBy,
//         required this.actionTakenDate,
//         required this.actionTakenTimestamp,
//         required this.taskReopenBy,
//         required this.taskReopenById,
//         required this.taskReopenDate,
//         required this.taskReopenTimestamp,
//         required this.taskFinishedBy,
//         required this.taskFinishedById,
//         required this.taskFinishedByDate,
//         required this.taskFinishedByTimestamp,
//         required this.taskEditBy,
//         required this.taskEditById,
//         required this.taskEditByDate,
//         required this.taskEditByTimestamp,
//         required this.taskDeleteBy,
//         required this.taskDeleteById,
//         required this.taskDeleteByDate,
//         required this.taskDeleteByTimestamp,
//         required this.sourceFrom,
//         required this.assignTo,
//         required this.company,
//         required this.documentNumber,
//
//       });
//
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       taskId: json['task_id'],
//       taskTitle: json['task_title'],
//       taskType: json['task_type'],
//       dueDate: json['due_date'],
//       taskTypeName: json['task_type_name'],
//       taskDescription: json['task_description'],
//       taskCreateById: json['task_create_by_id'],
//       taskCreateBy: json['task_create_by'],
//       taskCreateDate: json['task_create_date'],
//       taskCreateMonth: json['task_create_month'],
//       taskCreatedTimestamp: json['task_created_timestamp'],
//       taskStatus: json['task_status'],
//       taskStatusName: json['task_status_name'],
//       actionTakenById: json['action_taken_by_id'],
//       actionTakenBy: json['action_taken_by'],
//       actionTakenDate: json['action_taken_date'],
//       actionTakenTimestamp: json['action_taken_timestamp'],
//       taskReopenBy: json['task_reopen_by'],
//       taskReopenById: json['task_reopen_by_id'],
//       taskReopenDate: json['task_reopen_date'],
//       taskReopenTimestamp: json['task_reopen_timestamp'],
//       taskFinishedBy: json['task_finished_by'],
//       taskFinishedById: json['task_finished_by_id'],
//       taskFinishedByDate: json['task_finished_by_date'],
//       taskFinishedByTimestamp: json['task_finished_by_timestamp'],
//       taskEditBy: json['task_edit_by'],
//       taskEditById: json['task_edit_by_id'],
//       taskEditByDate: json['task_edit_by_date'],
//       taskEditByTimestamp: json['task_edit_by_timestamp'],
//       taskDeleteBy: json['task_delete_by'],
//       taskDeleteById: json['task_delete_by_id'],
//       taskDeleteByDate: json['task_delete_by_date'],
//       taskDeleteByTimestamp: json['task_delete_by_timestamp'],
//       sourceFrom: json['source_from'],
//       assignTo: json['assign_to'],
//       company: json['company'],
//       documentNumber: json['document_number'],
//     );
//   }
// }


var items = [
  'Status',
  '-All-',
  'Pending',
  'In Progress',
  'Completed'];
String dropdownvalue = 'Status';

var items1 = [
  'Source From',
  '-All-',
  'Skype',
  'Corporate Email',
  'Emojot Email',
  'On Call',
  'Company Chat',
  'Other',
];
String dropdownvalue1 = 'Source From';

var items2 = [
  'Assign To',
  '-All-',
  'Deshika',
  'Iqlas',
  'Udari',
  'Shahiru',
  'Dinethri',
  'Damith',
];
String dropdownvalue2 = 'Assign To';

var items3 = [
  'Company',
  'Beneficiary',
  '-All-',
  'A W M Riza',
  'Academy of Digital Business Pvt. Ltd',
  'Ajay Hathiramani',
  'Andea Pereira',
  'Andrew Downal',
  'Asanga Karunarathne',
  'Ashish Debey',
  'Askalu Lanka Pvt. Ltd',
  'Axis Tech Lanka (Pvt) Ltd',
  'B C M Azwath',
  'Ceylon Secretarial Services Pvt. Ltd',
  'Codify Lanka Pvt. Ltd',
  'Colonel Sujith Jayasekera',
  'Compume (Pvt) Ltd',
  'Corporate Business Solutions Pvt. Ltd',
  'Courtesy Law Lanka Pvt. Ltd',
  'Damith Gangodawilage',
  'David Murray',
  'DBA Alumni',
  'Deepani Attanayake',
  'Denver De Zylva',
  'Deshan Senadheera',
  'Dilhan Fernando',
  'Dinoo Perera',
  'Directpay (Pvt) Ltd',
  'DN Thurairajah & Co.',
  'Dr. Ishantha Jayasekera',
  'Dr. Shahani Markus',
  'E A Bimal Silva',
  'Eksath Perera',
  'Emojot Inc.',
  'Emojot Pvt. Ltd',
  'Fawas Ashraff',
  'Fernando Ventures Pvt. Ltd',
  'GK Wijayananada',
  'Gullies Beauty Care',
  'Hemal Kannangara',
  'Himali De Silva',
  'Idak Ceylon (Pvt) Ltd',
  'Imate Construction',
  'Ishan Dantanarayana',
  'Jagath Pathirane',
  'Jithain Hathiramani',
  'JK Chambers/Kanchana Senanayake',
  'Kalpitiya Discovery Diving Pvt. Ltd',
  'Kelsey Services/Kavan Weerasinghe',
  'L.D Wijerathne',
  'Lloyd Mills Pvt Ltd',
  'Lowcodeminds (Pvt) Ltd',
  'M R Muthalif',
  'Madu Rathnayake',
  'Maithri Liyange',
  'Mars Global Services Pvt. Ltd',
  'Maryse Perers',
  'Media Box/Ayesha',
  'Migara Perera',
  'Milinda Wattegerda',
  'Mithun Liyanage',
  'Mr. Lakshman Jayathilake',
  'Nature Confort Lanka Holdings Pvt. Ltd',
  'Nausha Raheem',
  'Naveen Wijetunga',
  'Nilangani De Silva',
  'Nirmana Traders/Surath Herath',
  'Nitmark Technologies Pvt. Ltd',
  'Nugawela Transport',
  'Off2 Lanka',
  'Paymedia Pvt. Ltd',
  'Pelicancube (Pvt) Ltd',
  'Pradipa Jayathilaka',
  'Prasanna Wijesiri',
  'Rajeeve Goonetileke',
  'Rasanga Shanaka',
  'Ravin',
  'Reena',
  'Ruchika Roonahewa',
  'Rumesh Athukorala',
  'Sachnitha Rajith Ponnamperuma',
  'Saliya Silva',
  'Samantha Maithriwardena',
  'Sameera Subashingha',
  'Sampath Gunawardena',
  'Sanjeeva Abyewardena',
  'Sayura Beer Shop/Sunil Punchibandara',
  'Shanil Fernando',
  'Shirani Kulasinghe',
  'Sonali Wicremaratne',
  'Squarehub (Pvt) Ltd',
  'Stephen Paulraj',
  'Sumudu Kumara Gunawarden',
  'Suren Karunakaran',
  'Tanya Gunasekera',
  'Taxperts Lanka Pvt. Ltd',
  'Tesman Melani',
  'Tharaka',
  'Tharumal Wijesimghe',
  'The Embazzy',
  'The Headmasters Pvt. Ltd',
  'Thingerbits Pvt. Ltd',
  'Tikiri Banda & Sons/Dr. Bandara',
  'Univiser (Pvt) Ltd',
  'UP Weerasinghe Properties Pvt. Ltd'
];
String dropdownvalue3 = 'Beneficiary';

var items4 = ['Priority','-All-', 'Top Urgent', 'Medium', 'Regular', 'Low'];
String dropdownvalue4 = 'Priority';

var items5 = ['Category','-All-', 'Regular', 'Ad hoc'];
String dropdownvalue5 = 'Category';


DateTime selectedDate = DateTime.now(); // Initialize selectedDate with a default value

Future<void> selectDate(
    BuildContext context, TextEditingController textEditingController) async {
  DateTime? newSelectedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2040),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.black,
            onPrimary: Colors.white,
            surface: Colors.blueGrey,
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: Colors.blue[500]!,
        ),
        child: child!,
      );
    },
  );


}

void setState(Null Function() param0) {
}

