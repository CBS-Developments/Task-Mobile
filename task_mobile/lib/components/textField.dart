import 'package:flutter/material.dart';

class TextFieldLogin extends StatelessWidget {
  final String topic;
  final String hintText;
  final TextEditingController controller;
  final Icon suficon;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText; // Add the obscureText property

  const TextFieldLogin({
    Key? key,
    required this.topic,
    required this.controller,
    required this.hintText,
    required this.suficon,
    this.onPressed,
    this.onSubmitted,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      color: Colors.white60,
      width: 300,
      height: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              topic,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: 290,
            height: 50,
            child: TextFormField(
              controller: controller,
              onFieldSubmitted: onSubmitted,
              obscureText: obscureText, // Set obscureText property
              decoration: InputDecoration(
                alignLabelWithHint: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                hintText: hintText,
                suffixIcon: suficon,
                contentPadding: const EdgeInsets.all(5.0),
              ),
            ),
          ),
          if (onPressed != null)
            const Text(''),
        ],
      ),
    );
  }
}
