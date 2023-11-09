import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Workspace_Lite/dashboards/dashMain.dart';
import 'package:Workspace_Lite/pages/createMainTask.dart';
import 'package:Workspace_Lite/pages/loginPage.dart';

import 'createAccountPopUps/assignToPopUp.dart';
import 'createAccountPopUps/beneficiaryPopUp.dart';
import 'createAccountPopUps/categoryPopUp.dart';
import 'createAccountPopUps/priorityPopUp.dart';
import 'createAccountPopUps/sourceFromPopUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          // ChangeNotifierProvider<StatusDropdownState>.value(
          //   value:
          //   StatusDropdownState(), // Provide an instance of StatusDropdownState
          // ),
          // ChangeNotifierProvider<TaskDropdownState>.value(
          //   value:
          //   TaskDropdownState(), // Provide an instance of TaskDropdownState
          // ),
          // ChangeNotifierProvider<AssignedDropdownState>.value(
          //   value:
          //   AssignedDropdownState(), // Provide an instance of AssignedDropdownState
          // ),
          // ChangeNotifierProvider<CompanyDropdownState>.value(
          //   value:
          //   CompanyDropdownState(), // Provide an instance of AssignedDropdownState
          // ),
          // ChangeNotifierProvider<LabelDropdownState>.value(
          //   value:
          //   LabelDropdownState(), // Provide an instance of AssignedDropdownState
          // ),
          ChangeNotifierProvider<BeneficiaryState>(
            create: (context) => BeneficiaryState(),
          ),
          ChangeNotifierProvider<DueDateState>(
            create: (context) => DueDateState(),
          ),
          ChangeNotifierProvider<AssignToState>.value(
            value: AssignToState(),
          ),

          ChangeNotifierProvider<PriorityState>.value(
            value: PriorityState(), // Provide an instance of PriorityState
          ),

          ChangeNotifierProvider<SourceFromState>.value(
            value: SourceFromState(),
          ),

          ChangeNotifierProvider<CategoryState>.value(
            value: CategoryState(),
          ),

          // ChangeNotifierProvider<EditBeneficiaryState>(
          //   create: (context) => EditBeneficiaryState(),
          // ),





        ],
        child: LandingPage(
            prefs: prefs), // Pass the plugin instance to LandingPage
      ),

    );
  }
}
class LandingPage extends StatelessWidget {
  final SharedPreferences prefs; // Add this line

  const LandingPage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _decideMainPage(),
    );
  }

  Widget _decideMainPage() {
    if (prefs.getString('login_state') != null) {
      return const DashMain();
    } else {
      return const LoginPage();
    }
  }
}

