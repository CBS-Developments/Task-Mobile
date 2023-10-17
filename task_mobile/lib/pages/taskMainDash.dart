import 'package:flutter/material.dart';
import 'package:task_mobile/dashboards/dashUser.dart';

import '../methods/sizes.dart';

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

  void _handleContainer0Pressed(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TaskMainDashboard()),
    // );
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

  void _handleContainer4Pressed(BuildContext context) {
    // Add your code for handling the fourth container button press here.
  }

  void _handleContainer5Pressed(BuildContext context) {
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
        color: Colors.white,
        textColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.containerTexts[index],
              style: const TextStyle(fontSize: 16.0),
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
              child: Container(
                width: 350,
                height: 700,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DashboardPageUser()),
                          );
                        }, icon: const Icon(Icons.arrow_back_rounded)),
                        const SizedBox(width: 10),
                        const Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 40,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }}