import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriorityState extends ChangeNotifier {
  String? _value = 'Priority'; // Default priority value

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}


void priorityPopupMenu(BuildContext context, PriorityState priorityState) {
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

  final priorityItems = [
    'Top Urgent', 'Medium', 'Regular', 'Low'
    // Add your priority levels here
  ];

  final popupMenuItems = priorityItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: priorityItems.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, priorityItems.indexOf(value)); // Return the index as the result
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
    if (value != null && value >= 0 && value < priorityItems.length) {
      final selectedValue = priorityItems[value];
      final priorityState = Provider.of<PriorityState>(context, listen: false);
      priorityState.value = selectedValue;
      print('Selected Priority: $selectedValue');
    }
  });
}
