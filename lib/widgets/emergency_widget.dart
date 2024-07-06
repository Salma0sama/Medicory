import 'package:flutter/material.dart';
import 'package:medicory/widgets/constants.dart';

class EmergencyTextField extends StatelessWidget {
  const EmergencyTextField({
    Key? key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.readOnly = true,
    this.color = kPrimaryColor,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final Widget prefixIcon;
  final bool readOnly;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? kPrimaryColor, // Always blue border color
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
                    color: color, // Always blue text color
                  ),
                ),
                TextField(
                  readOnly: readOnly,
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  maxLines: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
