import 'package:flutter/material.dart';
import 'package:medicory/widgets/constants.dart';

class EnableRadioRow extends StatefulWidget {
  final bool? valueChooseEnabled; // Change to bool?
  final void Function(bool?) onChanged;

  const EnableRadioRow({
    required this.valueChooseEnabled,
    required this.onChanged,
  });

  @override
  _EnableRadioRowState createState() => _EnableRadioRowState();
}

class _EnableRadioRowState extends State<EnableRadioRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Text(
            "Enabled :",
            style: TextStyle(
              fontSize: 19,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(width: 10),
          Radio<bool>(
            value: true,
            groupValue: widget.valueChooseEnabled, // Handle null case
            onChanged: widget.onChanged,
          ),
          Text(
            'True',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 20),
          Radio<bool>(
            value: false,
            groupValue: widget.valueChooseEnabled, // Handle null case
            onChanged: widget.onChanged,
          ),
          Text(
            'False',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
