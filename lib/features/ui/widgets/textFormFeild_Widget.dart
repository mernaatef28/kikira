import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';

class TextformfeildWidget extends StatelessWidget {
  final TextEditingController controller;
  final String fieldName;

  TextformfeildWidget({
    required this.controller,
    required this.fieldName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
      child: TextFormField(
        controller: controller,
        cursorColor: colorManager.kikiOrange,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 124, 124, 124), width: 2.0),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: fieldName,
          labelStyle: TextStyle(color: colorManager.kikiKohly ,fontWeight: FontWeight.w900),
        ),
        style: TextStyle(
          color: colorManager.kikiKohly, // Text color
          fontSize: 18.0,      // Font size
          fontWeight: FontWeight.bold, // Font weight
        ),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your paitent name ';
          }
          if (!RegExp(r'^\d+$').hasMatch(value)) {
            return 'Please enter a valid text';
          }
          return null;
        },
      ),
    );
  }
}
