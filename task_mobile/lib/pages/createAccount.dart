import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Workspace_Lite/components/textField.dart';
import 'package:Workspace_Lite/methods/sizes.dart';

import '../components/test.dart';
import '../methods/colors.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController empIDController = TextEditingController();


  Future<void> createUser(BuildContext context) async {
    // Validate input fields
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        mobileNumberController.text.isEmpty ||
        designationController.text.isEmpty ||
        passwordController.text.isEmpty ||
        empIDController.text.isEmpty ||
        companyController.text.isEmpty) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here

    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/createUser.php";

    var data = {
      "user_name": firstNameController.text.substring(0, 5) + mobileNumberController.text.substring(mobileNumberController.text.length - 2),
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "password_": passwordController.text,
      "phone": mobileNumberController.text,
      "designation": designationController.text,
      "company": companyController.text,
      "employee_ID": empIDController.text,
      "user_role": '0',
      "activate": '0',
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
        showSuccessSnackBar(context);// Show the success SnackBar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
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
    final snackBar = SnackBar(
      content: Text('Registration successful! Admin will Activate your account!!'),
      backgroundColor: Colors.blueAccent, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    height: 10,
                  ),

                  TextFieldLoginPassword(topic: 'First name', controller: firstNameController, hintText: '', suficon: Icon(Icons.person)),
                  TextFieldLoginPassword(topic: 'Last Name', controller: lastNameController, hintText: '', suficon: Icon(Icons.person)),
                  TextFieldLoginPassword(topic: 'Work Email Address', controller: emailController, hintText: '', suficon: Icon(Icons.email)),
                  TextFieldLoginPassword(topic: 'Phone', controller: mobileNumberController, hintText: '', suficon: Icon(Icons.phone)),
                  TextFieldLoginPassword(topic: 'Company name', controller: companyController, hintText: '', suficon: Icon(Icons.home_work)),
                  TextFieldLoginPassword(topic: 'Designation', controller: designationController, hintText: '', suficon: Icon(Icons.add)),
                  TextFieldLoginPassword(topic: 'Employee Id', controller: empIDController, hintText: '', suficon: Icon(Icons.numbers_rounded)),
                  TextFieldLoginPassword(topic: 'Password', controller: passwordController, hintText: '', suficon: Icon(Icons.remove_red_eye)),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 400,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        createUser(context);
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
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already using workspace ?",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            'Sign In',
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
