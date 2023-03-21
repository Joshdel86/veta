import 'package:flutter/material.dart';

class BuildGeneralInput extends StatelessWidget {
  BuildGeneralInput(
      {required this.inputController,
      required this.hint,
      required this.maskText,
      required this.inputKeyboard,
      required this.onChanged});

  final TextEditingController inputController;
  void Function(String)? onChanged;
  final String hint;
  final bool maskText;
  final TextInputType inputKeyboard;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputKeyboard,
      obscureText: maskText,
      controller: inputController,
      onChanged: onChanged,
      validator: (value) {
        if (inputController.text.isEmpty) {
          return hint.toString();
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
