import 'package:flutter/material.dart';
import 'package:task_mobile/components/textField.dart';
import 'package:task_mobile/methods/sizes.dart';

import '../methods/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  TextFieldLogin(topic: 'Email Address', controller: emailController, hintText: '', suficon:  const Icon(Icons.email)),
                  TextFieldLogin(topic: 'Password', controller: passwordController, hintText: '', suficon: const Icon(Icons.remove_red_eye_rounded)),

                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        const Text(
                          "Forgot your password ? ",
                          style: TextStyle(fontSize: 12),
                        ),
                        TextButton(
                            onPressed: () {   },
                            child: Text(
                              'Reset It',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: AppColor.tealLog),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 400,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // login(context);
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
                            fontSize: 15
                        ),
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const CreateAccountPage()),
                            // );
                          },
                          child: Text(
                            'Get Started',
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: AppColor.tealLog),
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
