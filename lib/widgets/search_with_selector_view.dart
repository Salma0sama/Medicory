import 'package:flutter/material.dart';

class SearchWithSelector extends StatelessWidget {
  final String labelText;
  final List<String> options;
  final String? selectedValue;
  final void Function(String?) onChanged;

  const SearchWithSelector({
    required this.labelText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Text(
            labelText,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(
              option,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
            value: option,
            groupValue: selectedValue,
            onChanged: onChanged,
          );
        }).toList(),
      ],
    );
  }
}
