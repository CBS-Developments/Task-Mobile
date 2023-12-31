import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Workspace_Lite/methods/colors.dart';
import 'package:Workspace_Lite/taskMainPages/auditMain.dart';
import 'package:Workspace_Lite/taskMainPages/companySecretarialMain.dart';
import 'package:Workspace_Lite/pages/createMainTask.dart';
import 'package:Workspace_Lite/taskMainPages/developmentMain.dart';
import 'package:Workspace_Lite/taskMainPages/financeMain.dart';
import 'package:Workspace_Lite/taskMainPages/AllmainTaskList.dart';
import 'package:Workspace_Lite/taskMainPages/talentMain.dart';
import 'package:Workspace_Lite/taskMainPages/taxationMain.dart';

import '../methods/sizes.dart';
import 'createMainTaskNew.dart';

class TaskMainDashboard extends StatefulWidget {


  final List<String> containerTexts = [
    'Taxation',
    'Talent Management',
    'Finance & Accounting',
    'Audit & Assurance',
    'Company Secretarial',
    'Developments',
  ];

  TaskMainDashboard({Key? key}) : super(key: key);

  @override
  State<TaskMainDashboard> createState() => _TaskMainDashboardState();
}

class _TaskMainDashboardState extends State<TaskMainDashboard> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
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

  void _handleContainer0Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaxationMainTask()),
    );
  }

  void _handleContainer1Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TalentMain()),
    );
  }

  void _handleContainer2Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinanceMain()),
    );
  }

  void _handleContainer3Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuditMain()),
    );
  }

  void _handleContainer4Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecretarialMain()),
    );
  }

  void _handleContainer5Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const DevelopmentMain()),
    );
  }

  Widget _buildContainer(int index, BuildContext context) {

    List<IconData> containerIcons = [
      Icons.attach_money,
      Icons.people,
      Icons.account_balance,
      Icons.assignment,
      Icons.business,
      Icons.developer_mode,
    ];

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: MaterialButton(
        onPressed: () {
          switch (index) {
            case 0:
              _handleContainer0Pressed(context);
              break;
            case 1:
              _handleContainer1Pressed(context);
              break;
            case 2:
              _handleContainer2Pressed(context);
              break;
            case 3:
              _handleContainer3Pressed(context);
              break;
            case 4:
              _handleContainer4Pressed(context);
              break;
            case 5:
              _handleContainer5Pressed(context);
              break;
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2.0,
        color: Colors.grey[200],
        textColor: Colors.teal[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              containerIcons[index], // Set the icon for each container
              size: 36.0,             // Customize the icon size
              color: Colors.teal[800],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.containerTexts[index],
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainTaskList()),
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200], // Set the background color
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0), // Set padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set border radius
        ),
        elevation: 2.0,
      ),
      child: Text(
        'All Tasks',
        style: TextStyle(
          color: Colors.teal[800], // Set text color
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workspace',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1.0,
      ),

      body: ListView(
        children: [
          Container(
            color: Colors.white,
            width: getPageWidth(context),
            height: getPageHeight(context),
            child: Center(
              child: Container(
                width: 350,
                height: 800,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          children: List.generate(6, (index) {
                            return _buildContainer(index, context);
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 20, // Adjust the spacing between the GridView and Text Button
                      ),
                      _buildTextButton(context), // Add the Text Button here
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateMainTaskPage()),
          );
        },
        backgroundColor: AppColor.tealLog,
        child: const Icon(Icons.add), // Customize the button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Adjust the location if needed
    );
  }
}
