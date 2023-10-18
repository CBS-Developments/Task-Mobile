import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SourceFromState extends ChangeNotifier {
  String? _value = 'Source From';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}

void sourceFromPopupMenu(BuildContext context, sourceFromState) {
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

  final sourceFromItems = [
    'Skype',
    'Corporate Email',
    'Emojot Email',
    'On Call',
    'Company Chat',
    'Other',
    // Add your "Source From" items here
  ];

  final popupMenuItems = sourceFromItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: sourceFromItems.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, sourceFromItems.indexOf(value)); // Return the index as the result
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
    if (value != null && value >= 0 && value < sourceFromItems.length) {
      final selectedValue = sourceFromItems[value];
      final sourceFromState = Provider.of<SourceFromState>(context, listen: false);
      sourceFromState.value = selectedValue;
      print('Selected Source From: $selectedValue');
    }
  });
}


