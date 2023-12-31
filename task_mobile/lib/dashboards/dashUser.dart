import 'package:Workspace_Lite/methods/colors.dart';
import 'package:Workspace_Lite/pages/taskLog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../methods/sizes.dart';
import '../pages/loginPage.dart';
import '../pages/taskMainDash.dart';

class DashboardPageUser extends StatefulWidget {
  final List<String> containerTexts = [
    'Tasks',
    'Task Log',
    'Chat',
    'Calendar',
  ];

  final List<String> imagePaths = [
    'images/task.png',
    'images/email.png',
    'images/chat.png',
    'images/cal.png',
  ];

  DashboardPageUser({Key? key}) : super(key: key);

  @override
  State<DashboardPageUser> createState() => _DashboardPageUserState();
}

class _DashboardPageUserState extends State<DashboardPageUser> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";
  String email = "";
  String password_ = "";
  String employee_ID = "";
  String designation = "";
  String company = "";

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
      email = prefs.getString('email') ?? "";
      password_ = prefs.getString('password_') ?? "";
      employee_ID = prefs.getString('employee_ID') ?? "";
      designation = prefs.getString('designation') ?? "";
      company = prefs.getString('company') ?? "";
    });
  }
  void _handleContainer0Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskMainDashboard()),
    );
  }

  void _handleContainer1Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskLogPage()),
    );
  }

  void _handleContainer2Pressed(BuildContext context) {
    // Add your code for handling the third container button press here.
  }

  void _handleContainer3Pressed(BuildContext context) {
    // Add your code for handling the fourth container button press here.
  }

  Widget _buildContainer(int index, BuildContext context) {
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
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2.0,
        color: Colors.grey[200],
        textColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePaths[index],
              width: 150.0,
              height: 130.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.containerTexts[index],
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ListView(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Open the drawer when the custom menu button is clicked
                          Scaffold.of(scaffoldContext).openDrawer();
                        },
                        icon: const Icon(Icons.menu_rounded),
                      ),
                      const SizedBox(width: 60),
                       Text(
                        'Workspace',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: GridView.count(
                      crossAxisCount: 1,
                      shrinkWrap: true,
                      childAspectRatio: 1.8,
                      children: List.generate(2, (index) {
                        return _buildContainer(index, context);
                      }),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$firstName $lastName'),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.account_circle, size: 50, color: Colors.grey,),
              ),
              decoration: BoxDecoration(
                color: Colors.teal, // Change the color to your desired color
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    'ID: $employee_ID',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                  ' Designation: $designation',
                    style:  TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(Icons.phone,size: 16,),
                  ),
                  Text(
                    ': ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '0$phone',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 3.0),
                    child: Icon(Icons.maps_home_work_outlined,size: 16,),
                  ),
                  Text(
                    ': ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    company,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70,),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove("login_state"); // Remove the "login_state" key
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }),
                );
              },
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Set your desired background color
                  borderRadius: BorderRadius.circular(8.0), // Set your desired border radius
                ),
                padding: EdgeInsets.all(15.0), // Set your desired padding
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red, // Set your desired text color
                      fontSize: 16.0, // Set your desired text size
                    ),
                  ),
                ),
              ),
            ),

            // Add other drawer items here
          ],
        ),
      ),

    );
  }
}
