import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/dashboards/dashadmin.dart';

import '../methods/sizes.dart';
import '../pages/loginPage.dart';
import '../pages/taskMainDash.dart';

class DashboardPageUser extends StatefulWidget {
  final List<String> containerTexts = [
    'Tasks',
    'Email',
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
  void _handleContainer0Pressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskMainDashboard()),
    );
  }

  void _handleContainer1Pressed(BuildContext context) {
    // Add your code for handling the second container button press here.
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
        color: Colors.white,
        textColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePaths[index],
              width: 130.0,
              height: 100.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.containerTexts[index],
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            width: getPageWidth(context),
            height: getPageHeight(context),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 350,
                  height: 700,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
                            const SizedBox(width: 60),
                            const Text(
                              'Workspace',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(width: 60),
                            IconButton(onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              prefs.remove("login_state"); // Remove the "login_state" key
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const LoginPage();
                                }),
                              );
                            },
                                icon: const Icon(Icons.logout))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          children: List.generate(4, (index) {
                            return _buildContainer(index, context);
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
