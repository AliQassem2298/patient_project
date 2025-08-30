import 'package:flutter/material.dart';

Widget buttonwidget({
  final double width = double.infinity,
  final Color background = const Color.fromARGB(255, 129, 237, 194),
  final bool toUpperCase = true,
  required double radius,
  required final String text,
  required Function fucntion,
}) =>
    Container(
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: ElevatedButton(
        onPressed: () => fucntion(),
        child: Text(
          toUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
Widget Textfield({
  int? maxlength,
  required Icon icons,
  required String labelText,
  required TextInputType type,
  required Function validate,
  Function? onSubmit,
  TextEditingController? controller,
  Function? onChange,
  bool obscureText = false,
  InputDecoration? decoration,
}) =>
    TextFormField(
      maxLength: maxlength,
      validator: (value) => validate(value),
      keyboardType: type,
      decoration: decoration,
      obscureText: obscureText,
      controller: controller,
    );

Widget elvatButton({
  Color foregroundColor =const Color.fromARGB(255, 129, 237, 194),
  Color overlayColor = const Color.fromARGB(255, 232, 245, 233),
  Color shadowColor = const Color.fromARGB(255, 129, 237, 194),
  required String text,
  required Function function,
}) =>
    ElevatedButton(
      onPressed: () => function(),
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        overlayColor: overlayColor,
        minimumSize: const Size(double.infinity, 50),
        shadowColor: shadowColor,
      ),
      child: Text(
        text,
      ),
    );
