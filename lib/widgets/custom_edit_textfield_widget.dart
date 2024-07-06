import 'package:flutter/material.dart';

class CustomEditTextField extends StatelessWidget {
  const CustomEditTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.onchange,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.readOnly = false,
  }) : super(key: key);

  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function(dynamic) onchange;
  final Widget prefixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Always blue border color
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          prefixIcon,
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Always blue text color
                  ),
                ),
                TextField(
                  keyboardType: keyboardType ?? TextInputType.text,
                  readOnly: readOnly,
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: hintText,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  maxLines: null,
                  onChanged: (text) {
                    onchange(text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
