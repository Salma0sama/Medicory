import 'package:flutter/material.dart';

class ButtonDetails {
  final String Text;
  final Function() Navigation;
  const ButtonDetails({required this.Navigation, required this.Text});
}

class AddTextField {
  final Function(String) onchange;
  final String Label;
  final String hintText;
  final TextInputType? keyboardType; // Define keyboardType property

  AddTextField({
    required this.onchange,
    required this.Label,
    required this.hintText,
    this.keyboardType, // Make keyboardType optional
  });
}

class AddDropdownButton {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const AddDropdownButton({
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });
}

class RowData {
  final String label;
  final dynamic value;

  const RowData({required this.label, required this.value});
}
