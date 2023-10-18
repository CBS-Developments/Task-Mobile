
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryState extends ChangeNotifier {
  int? _selectedIndex;
  String? _value = 'Category';

  int? get selectedIndex => _selectedIndex;
  String? get value => _value;

  set selectedCategory(MapEntry<int, String>? newValue) {
    if (newValue != null) {
      _selectedIndex = newValue.key;
      _value = newValue.value;
      notifyListeners();
    }
  }
}

void categoryPopupMenu(BuildContext context, CategoryState categoryState) {
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

  final categoryItems = [
    'Taxation - TAS',
    'Talent Management - TMS',
    'Finance & Accounting - AFSS',
    'Audit & Assurance - ASS',
    'Company Secretarial - CSS',
    'Development - DEV'
    // Add your category items here
  ];

  final popupMenuItems = categoryItems.asMap().entries.map<PopupMenuItem<MapEntry<int, String>>>((entry) {
    final index = entry.key;
    final value = entry.value;
    return PopupMenuItem<MapEntry<int, String>>(
      value: MapEntry(index, value), // Using a MapEntry to store both index and value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, MapEntry(index, value)); // Return a MapEntry with the index and value
          print(value);
          print(index);
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
    categoryState.selectedCategory = value;
  });
}
