import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AssignToState extends ChangeNotifier {
  String? _value = 'Assign To';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}


void assignToPopupMenu(BuildContext context, AssignToState assignToState) {
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final RenderBox button = context.findRenderObject() as RenderBox;

  final double topOffset = 500; // Adjust this value as needed
  final double leftOffset = 550; // Adjust this value as needed

  final position = RelativeRect.fromLTRB(
    leftOffset,
    topOffset,
    leftOffset + button.size.width,
    topOffset + button.size.height,
  );

  final assignToItems = [
    'Assign To',
    'Deshika',
    'Iqlas',
    'Udari',
    'Shahiru',
    'Dinethri',
    'Damith',
    // Add your "Assign To" items here
  ];

  final popupMenuItems = assignToItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: assignToItems.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, assignToItems.indexOf(value)); // Return the index as the result
        },
        child: Text(value),
      ),
    );
  }).toList();

  showMenu(
    context: context,
    position: position,
    items: popupMenuItems,
    elevation: 8,
  ).then((value) {
    if (value != null && value >= 0 && value < assignToItems.length) {
      final selectedValue = assignToItems[value];
      final assignToState = Provider.of<AssignToState>(context, listen: false);
      assignToState.value = selectedValue;
      print('Selected Assign To: $selectedValue');
    }
  });
}
