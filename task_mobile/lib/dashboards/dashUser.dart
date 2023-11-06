// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_mobile/dashboards/dashadmin.dart';
//
// import '../methods/sizes.dart';
// import '../pages/loginPage.dart';
// import '../pages/taskMainDash.dart';
//
// class DashboardPageUser extends StatefulWidget {
//   final List<String> containerTexts = [
//     'Tasks',
//     'Email',
//     'Chat',
//     'Calendar',
//   ];
//
//   final List<String> imagePaths = [
//     'images/task.png',
//     'images/email.png',
//     'images/chat.png',
//     'images/cal.png',
//   ];
//
//   DashboardPageUser({Key? key}) : super(key: key);
//
//   @override
//   State<DashboardPageUser> createState() => _DashboardPageUserState();
// }
//
// class _DashboardPageUserState extends State<DashboardPageUser> {
//   void _handleContainer0Pressed(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => TaskMainDashboard()),
//     );
//   }
//
//   void _handleContainer1Pressed(BuildContext context) {
//     // Add your code for handling the second container button press here.
//   }
//
//   void _handleContainer2Pressed(BuildContext context) {
//     // Add your code for handling the third container button press here.
//   }
//
//   void _handleContainer3Pressed(BuildContext context) {
//     // Add your code for handling the fourth container button press here.
//   }
//
//   Widget _buildContainer(int index, BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10.0),
//       child: MaterialButton(
//         onPressed: () {
//           switch (index) {
//             case 0:
//               _handleContainer0Pressed(context);
//               break;
//             case 1:
//               _handleContainer1Pressed(context);
//               break;
//             case 2:
//               _handleContainer2Pressed(context);
//               break;
//             case 3:
//               _handleContainer3Pressed(context);
//               break;
//           }
//         },
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         elevation: 2.0,
//         color: Colors.white,
//         textColor: Colors.black,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               widget.imagePaths[index],
//               width: 130.0,
//               height: 100.0,
//             ),
//             const SizedBox(height: 10.0),
//             Text(
//               widget.containerTexts[index],
//               style: const TextStyle(fontSize: 14.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           Container(
//             color: Colors.white,
//             width: getPageWidth(context),
//             height: getPageHeight(context),
//             child: Center(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   width: 350,
//                   height: 700,
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
//                             const SizedBox(width: 60),
//                             const Text(
//                               'Workspace',
//                               style: TextStyle(
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepPurple,
//                               ),
//                             ),
//                             const SizedBox(width: 60),
//                             IconButton(onPressed: () async {
//                               final prefs = await SharedPreferences.getInstance();
//                               prefs.remove("login_state"); // Remove the "login_state" key
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) {
//                                   return const LoginPage();
//                                 }),
//                               );
//                             },
//                                 icon: const Icon(Icons.logout))
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const Divider(),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(5.0),
//                         child: GridView.count(
//                           crossAxisCount: 2,
//                           shrinkWrap: true,
//                           children: List.generate(4, (index) {
//                             return _buildContainer(index, context);
//                           }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/dashboards/dashadmin.dart';

import '../methods/sizes.dart';
import '../pages/loginPage.dart';
import '../pages/taskMainDash.dart';

class DashboardPageUser extends StatefulWidget {
  // ... (no changes here)
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
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ListView(
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
                              const Text(
                                'Workspace',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(width: 60),
                              IconButton(
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
                                icon: const Icon(Icons.logout),
                              ),
                            ],
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
            // Add other drawer items here
          ],
        ),
      ),

    );
  }
}
