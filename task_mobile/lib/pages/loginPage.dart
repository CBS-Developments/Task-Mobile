import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_mobile/components/textField.dart';
import 'package:task_mobile/methods/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:task_mobile/dashboards/dashMain.dart';

import '../components/test.dart';
import '../dashboards/dashUser.dart';
import '../methods/colors.dart';
import 'createAccount.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> login(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      snackBar(context, "Email can't be empty", Colors.redAccent);
      return false;
    }

    if (emailController.text.trim().length < 3) {
      snackBar(context, "Invalid Email.", Colors.yellow);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/login.php";
    var data = {
      "email": emailController.text,
      "password_": passwordController.text,
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
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
      bool status = result['status'];
      if (status) {
        if (result['activate'] == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login_state', '1');
          prefs.setString('user_name', result['user_name']);
          prefs.setString('first_name', result['first_name']);
          prefs.setString('last_name', result['last_name']);
          prefs.setString('email', result['email']);
          prefs.setString('password_', result['password_']);
          prefs.setString('phone', result['phone']);
          prefs.setString('employee_ID', result['employee_ID']);
          prefs.setString('designation', result['designation']);
          prefs.setString('company', result['company']);
          prefs.setString('user_role', result['user_role']);
          prefs.setString('activate', result['activate']);

          if (!mounted) return true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashMain()),
          );
        } else {
          snackBar(context, "Account Deactivated",
              Colors.redAccent); // Show Snackbar for deactivated account
        }
      } else {
        snackBar(context, "Incorrect Password",
            Colors.yellow); // Show Snackbar for incorrect password
      }
    } else {
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: getPageWidth(context),
        height: getPageHeight(context),
        child: Center(
          child: Container(
            width: 290,
            height: 700,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Workspace',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 150,
                  ),
                  TextFieldLogin(
                    topic: 'Email Address',
                    controller: emailController,
                    hintText: '',
                    suficon: const Icon(Icons.email),
                    onPressed: () {},
                    onSubmitted: (value) {
                      login(context);
                    },
                  ),
                  TextFieldLogin(
                    topic: 'Password',
                    obscureText: true,
                    controller: passwordController,
                    hintText: '',
                    suficon: const Icon(Icons.remove_red_eye_rounded),
                    onPressed: () {},
                    onSubmitted: (value) {
                      login(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        const Text(
                          "Forgot your password ? ",
                          style: TextStyle(fontSize: 12),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Reset It',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.tealLog),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    height: 50,
                    width: 400,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPageUser()),
                        );
                        //login(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.loginF,
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New to Workspace ?",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateAccountPage()),
                            );
                          },
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColor.tealLog),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
