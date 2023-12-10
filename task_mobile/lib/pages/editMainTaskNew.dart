import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/test.dart';
import '../methods/colors.dart';
import '../methods/sizes.dart';
import 'createSubTask.dart';

class EditMainTaskPage extends StatefulWidget {
  final MainTask mainTaskDetails;
  const EditMainTaskPage({super.key, required this.mainTaskDetails});

  @override
  State<EditMainTaskPage> createState() => _EditMainTaskPageState();
}

class _EditMainTaskPageState extends State<EditMainTaskPage> {

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";



  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String priority = '';
  String dueDate = '';
  String sourceFrom = ''; // Set a default value that exists in the dropdown items
  String assignTo = ''; // Default value from the items list
  String beneficiary = ''; // Default value from the items list
  String categoryName = ''; // Default value from the items list
  String category = ''; // Default value from the items list
  int selectedIndex = -1; // Default index value // Default index value

  List<String> selectedAssignTo = [];


  List<String> categoryNames = [
    'Taxation - TAS',
    'Talent Management - TMS',
    'Finance & Accounting - AFSS',
    'Audit & Assurance - ASS',
    'Company Secretarial - CSS',
    'Development - DEV'
    // Add your category items here
  ];

  List<String> beneficiaries = ['Beneficiary',
    'A W M Riza',
    'Academy of Digital Business Pvt. Ltd',
    'Ajay Hathiramani',
    'Andea Pereira',
    'Andrew Downal',
    'Asanga Karunarathne',
    'Ashish Debey',
    'Askalu Lanka Pvt. Ltd',
    'Axis Tech Lanka (Pvt) Ltd',
    'B C M Azwath',
    'Ceylon Secretarial Services Pvt. Ltd',
    'Codify Lanka Pvt. Ltd',
    'Colonel Sujith Jayasekera',
    'Compume (Pvt) Ltd',
    'Corporate Business Solutions Pvt. Ltd',
    'Courtesy Law Lanka Pvt. Ltd',
    'Damith Gangodawilage',
    'David Murray',
    'DBA Alumni',
    'Deepani Attanayake',
    'Denver De Zylva',
    'Deshan Senadheera',
    'Dilhan Fernando',
    'Dinoo Perera',
    'Directpay (Pvt) Ltd',
    'DN Thurairajah & Co.',
    'Dr. Ishantha Jayasekera',
    'Dr. Shahani Markus',
    'E A Bimal Silva',
    'Eksath Perera',
    'Emojot Inc.',
    'Emojot Pvt. Ltd',
    'Fawas Ashraff',
    'Fernando Ventures Pvt. Ltd',
    'GK Wijayananada',
    'Gullies Beauty Care',
    'Hemal Kannangara',
    'Himali De Silva',
    'Idak Ceylon (Pvt) Ltd',
    'Imate Construction',
    'Ishan Dantanarayana',
    'Jagath Pathirane',
    'Jithain Hathiramani',
    'JK Chambers/Kanchana Senanayake',
    'Kalpitiya Discovery Diving Pvt. Ltd',
    'Kelsey Services/Kavan Weerasinghe',
    'L.D Wijerathne',
    'Lloyd Mills Pvt Ltd',
    'Lowcodeminds (Pvt) Ltd',
    'M R Muthalif',
    'Madu Rathnayake',
    'Maithri Liyange',
    'Mars Global Services Pvt. Ltd',
    'Maryse Perers',
    'Media Box/Ayesha',
    'Migara Perera',
    'Milinda Wattegerda',
    'Mithun Liyanage',
    'Mr. Lakshman Jayathilake',
    'Nature Confort Lanka Holdings Pvt. Ltd',
    'Nausha Raheem',
    'Naveen Wijetunga',
    'Nilangani De Silva',
    'Nirmana Traders/Surath Herath',
    'Nitmark Technologies Pvt. Ltd',
    'Nugawela Transport',
    'Off2 Lanka',
    'Paymedia Pvt. Ltd',
    'Pelicancube (Pvt) Ltd',
    'Pradipa Jayathilaka',
    'Prasanna Wijesiri',
    'Rajeeve Goonetileke',
    'Rasanga Shanaka',
    'Ravin',
    'Reena',
    'Ruchika Roonahewa',
    'Rumesh Athukorala',
    'Sachnitha Rajith Ponnamperuma',
    'Saliya Silva',
    'Samantha Maithriwardena',
    'Sameera Subashingha',
    'Sampath Gunawardena',
    'Sanjeeva Abyewardena',
    'Sayura Beer Shop/Sunil Punchibandara',
    'Shanil Fernando',
    'Shirani Kulasinghe',
    'Sonali Wicremaratne',
    'Squarehub (Pvt) Ltd',
    'Stephen Paulraj',
    'Sumudu Kumara Gunawarden',
    'Suren Karunakaran',
    'Tanya Gunasekera',
    'Taxperts Lanka Pvt. Ltd',
    'Tesman Melani',
    'Tharaka',
    'Tharumal Wijesimghe',
    'The Embazzy',
    'The Headmasters Pvt. Ltd',
    'Thingerbits Pvt. Ltd',
    'Tikiri Banda & Sons/Dr. Bandara',
    'Univiser (Pvt) Ltd',
    'UP Weerasinghe Properties Pvt. Ltd'];

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getCurrentMonth() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yy-MM').format(now);
    return formattedDate;
  }

  String generatedTaskId() {
    final random = Random();
    int min = 1; // Smallest 9-digit number
    int max = 999999999; // Largest 9-digit number
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber.toString().padLeft(9, '0');
  }

  @override
  void initState() {
    super.initState();
    // Initialize assignTo based on selectedAssignTo
    // assignTo = selectedAssignTo.toString();
    loadData();
    beneficiary = widget.mainTaskDetails.company;
    priority = widget.mainTaskDetails.taskTypeName;
    sourceFrom = widget.mainTaskDetails.sourceFrom;
    assignTo = widget.mainTaskDetails.assignTo;
    categoryName = widget.mainTaskDetails.category_name;
    category = widget.mainTaskDetails.category;
    titleController.text =  widget.mainTaskDetails.taskTitle;
    descriptionController.text =  widget.mainTaskDetails.task_description;
    dueDate = widget.mainTaskDetails.dueDate;
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";
      print(
          'Data laded in create main task > userName: $userName > userRole: $userRole');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      // Define the desired date format
      final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Example format: yyyy-MM-dd

      setState(() {
        // Format the picked date using the defined format
        dueDate = formatter.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  SelectableText(
          widget.mainTaskDetails.taskTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1.0,
      ),

      body:
      Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: getPageHeight(context),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey, // Shadow color
                            blurRadius: 5, // Spread radius
                            offset: Offset(0, 3), // Offset in x and y directions
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: titleController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Task Title',
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: 'Description',
                                hintText: 'Description',
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),




                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text("Beneficiary:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 15),),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                            return beneficiaries.where((String option) {
                                              return option.toLowerCase().contains(
                                                textEditingValue.text.toLowerCase(),
                                              );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              beneficiary = value;
                                            });
                                          },
                                          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText: '${widget.mainTaskDetails.company}',
                                                hintStyle: TextStyle(fontSize: 15),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                              BuildContext context,
                                              AutocompleteOnSelected<String> onSelected,
                                              Iterable<String> options,
                                              ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints: BoxConstraints(maxHeight: 200),
                                                  width: MediaQuery.of(context).size.width*0.55,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) => ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),


                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Due Date:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 15),),
                                      TextButton(
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              dueDate.isEmpty ? 'Select Date' : '$dueDate',style: TextStyle(fontSize: 15,color: Colors.black87),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Icon(Icons.calendar_month_rounded,color: Colors.black87,size: 16,),
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),


                            ],
                          ),





                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:3,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                  child: MultiSelectFormField(
                                    autovalidate: AutovalidateMode.always,
                                    title: Text('Assign To: ',style: TextStyle(color: AppColor.appDarkBlue,fontSize: 15),),
                                    dataSource: [
                                      {
                                        "display": "Deshika",
                                        "value": "Deshika",
                                      },
                                      {
                                        "display": "Damith",
                                        "value": "Damith",
                                      },
                                      {
                                        "display": "Iqlas",
                                        "value": "Iqlas",
                                      },
                                      {
                                        "display": "Udari",
                                        "value": "Udari",
                                      },
                                      {
                                        "display": "Shahiru",
                                        "value": "Shahiru",
                                      },
                                      {
                                        "display": "Dinethri",
                                        "value": "Dinethri",
                                      },
                                      {
                                        "display": "Sulakshana",
                                        "value": "Sulakshana",
                                      },
                                      {
                                        "display": "Samadhi",
                                        "value": "Samadhi",
                                      },
                                      {
                                        "display": "Sanjana",
                                        "value": "Sanjana",
                                      },
                                      // Add other items as needed
                                    ],
                                    textField: 'display',
                                    hintWidget: Text('${widget.mainTaskDetails.assignTo}'),
                                    valueField: 'value',
                                    okButtonLabel: 'OK',
                                    cancelButtonLabel: 'CANCEL',
                                    initialValue: selectedAssignTo,
                                    onSaved: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        selectedAssignTo = value.cast<String>(); // Ensure the value is a list of strings
                                        assignTo = selectedAssignTo.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text("Priority:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 15),),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                            return ['Top Urgent', 'Medium', 'Regular', 'Low'].where((String option) {
                                              return option.toLowerCase().contains(
                                                textEditingValue.text.toLowerCase(),
                                              );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              priority = value;
                                            });
                                          },
                                          fieldViewBuilder: (
                                              BuildContext context,
                                              TextEditingController textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted,
                                              ) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText: '${widget.mainTaskDetails.taskTypeName}',
                                                hintStyle: TextStyle(fontSize: 15),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                              BuildContext context,
                                              AutocompleteOnSelected<String> onSelected,
                                              Iterable<String> options,
                                              ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints: BoxConstraints(maxHeight: 200),
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) => ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text("Source From:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 15),),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                            return ['Skype',
                                              'Corporate Email',
                                              'Emojot Email',
                                              'On Call',
                                              'Company Chat',
                                              'Other',].where((String option) {
                                              return option.toLowerCase().contains(
                                                textEditingValue.text.toLowerCase(),
                                              );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              sourceFrom = value;
                                            });
                                          },
                                          fieldViewBuilder: (
                                              BuildContext context,
                                              TextEditingController textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted,
                                              ) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText: '${widget.mainTaskDetails.sourceFrom}',
                                                hintStyle: TextStyle(fontSize: 15),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                              BuildContext context,
                                              AutocompleteOnSelected<String> onSelected,
                                              Iterable<String> options,
                                              ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints: BoxConstraints(maxHeight: 200),
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) => ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text("Category:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 15),),

                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                            return categoryNames.where((String option) {
                                              return option.toLowerCase().contains(
                                                textEditingValue.text.toLowerCase(),
                                              );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              categoryName = value;
                                              selectedIndex = categoryNames.indexOf(value);
                                              category = selectedIndex.toString(); // Convert selectedIndex to string
                                            });
                                          },
                                          fieldViewBuilder: (
                                              BuildContext context,
                                              TextEditingController textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted,
                                              ) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText: '${widget.mainTaskDetails.category_name}',
                                                hintStyle: TextStyle(fontSize: 15),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                              BuildContext context,
                                              AutocompleteOnSelected<String> onSelected,
                                              Iterable<String> options,
                                              ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints: BoxConstraints(maxHeight: 100),
                                                  width: MediaQuery.of(context).size.width*0.55,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) => ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 40,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 40,
                                width: 140,
                                padding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    editMainTask();
                                    print('Title:${titleController.text}');
                                    print('Description:${descriptionController.text}');
                                    print('Selected Priority:${priority}');
                                    print('Selected Due Date:${dueDate}');
                                    print('Selected Source From:${sourceFrom}');
                                    print('Selected Assign To:${assignTo}');
                                    print('Selected Beneficiary:${beneficiary}');
                                    print('Selected Category Name:${categoryName}');
                                    print('Selected Category:${category}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 140,
                                padding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20,),





                        ],
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
  }

  Future<bool> editMainTask() async {
    String logType ='Main Task';
    String logSummary ='Edited';
    String logDetails ='';
    var data = {
      "task_id": widget.mainTaskDetails.taskId,
      "task_title": titleController.text,
      "task_type_name": priority,
      "task_description": descriptionController.text,
      "task_status_name": widget.mainTaskDetails.taskStatusName,
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDate(),
      "action_taken_timestamp": getCurrentDate(),
      "task_edit_by": userName,
      "task_edit_by_id": firstName,
      "task_edit_by_date": getCurrentDate(),
      "task_edit_by_timestamp": getCurrentDate(),
      "company": beneficiary,
      "due_date": dueDate,
      "assign_to": assignTo,
      "source_from": sourceFrom,
      "category_name": categoryName,
      "category": category,
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/editMainTask.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Main task edit Successful');
          addLog(context,
              taskId: widget.mainTaskDetails.taskId,
              taskName: widget.mainTaskDetails.taskTitle,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          snackBar(context, " Edit Main Task successful!", Colors.green);
          Navigator.pushNamed(context, '/Task');

          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }

  Future<void> addLog(BuildContext context, {required String taskId, required String taskName, required String createBy, required String createByID, required String logType, required String logSummary, required String logDetails}) async {
    var url = "http://dev.workspace.cbs.lk/addLogUpdate.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": logSummary,
      "log_type": logType,
      "log_details": logDetails,
      "log_create_by": createBy,
      "log_create_by_id": createByID,
      "log_create_by_date": getCurrentDate(),
      "log_create_by_month": getCurrentMonth(),
      "log_create_by_year": '',
      "log_created_by_timestamp": getCurrentDateTime(),
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
        print('Log added!!');
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }

  }
}
