import 'package:flutter/material.dart';
import 'package:medicory/widgets/button_widget.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed, required this.text});
  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Button(
            onPressed: onPressed,
            text: text,
          ),
        ),
      ],
    );
  }
}
