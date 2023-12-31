
import 'package:flutter/material.dart';

class TextFieldLoginPassword extends StatefulWidget {
  final String topic;
  final String hintText;
  final TextEditingController controller;
  final Icon suficon;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;

  const TextFieldLoginPassword({
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
  _TextFieldLoginPasswordState createState() => _TextFieldLoginPasswordState();
}

class _TextFieldLoginPasswordState extends State<TextFieldLoginPassword> {
  bool _obscureText = true;

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
              widget.topic,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: 290,
            height: 50,
            child: TextFormField(
              controller: widget.controller,
              onFieldSubmitted: widget.onSubmitted,
              obscureText: _obscureText,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                hintText: widget.hintText,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                  },
                  child: widget.suficon,
                ),
                contentPadding: const EdgeInsets.all(5.0),
              ),
            ),
          ),
          if (widget.onPressed != null) const Text(''),
        ],
      ),
    );
  }
}
