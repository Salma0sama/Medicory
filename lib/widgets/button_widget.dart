import 'package:flutter/material.dart';
import 'package:medicory/widgets/constants.dart';

class Button extends StatefulWidget {
  const Button(
      {Key? key, required this.onPressed, required this.text, this.color});
  final Function() onPressed;
  final String text;
  final Color? color;
  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color ?? kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(120, 40),
            ),
            onPressed: widget.onPressed,
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 19,
                color: kTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
