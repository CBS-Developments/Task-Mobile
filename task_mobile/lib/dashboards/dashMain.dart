import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/dashboards/dashUser.dart';
import 'package:task_mobile/dashboards/dashadmin.dart';


class DashMain extends StatelessWidget {
  const DashMain({super.key});

  Future<int> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRoleString = prefs.getString('user_role'); // Fetch as String
    if (userRoleString != null) {
      return int.parse(userRoleString); // Convert to int
    } else {
      return -1; // Default value if not found
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching user_role
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error if there's an issue fetching user_role
          return Text('Error: ${snapshot.error}');
        } else {
          // Check the value of user_role and navigate accordingly
          final userRole = snapshot.data;

          if (userRole == 0) {
            print('user_role: $userRole'); // Print user_role
            return DashboardPageUser(); // Navigate to PageOne

          } else if (userRole == 1) {
            print('user_role: $userRole'); // Print user_role
            return const DashboardPageAdmin(); // Navigate to PageTwo
          } else {
            return Text('Invalid user_role'); // Handle other cases
          }
        }
      },
    );
  }
}
