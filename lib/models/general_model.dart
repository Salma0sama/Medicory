import 'package:flutter/material.dart';

class ButtonDetails {
  final String Text;
  final Function() Navigation;
  const ButtonDetails({required this.Navigation, required this.Text});
}

class AddTextField {
  final dynamic Function(String) onUpdate; // Update to onUpdate
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  AddTextField({
    required this.onUpdate, // Updated to onUpdate
    required this.label,
    required this.hintText,
    this.keyboardType,
    required this.controller,
  });
}

class AddDropdownButton {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  AddDropdownButton({
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

class Prescription {
  final int rank;
  final String text;
  final Function()? onTap;

  const Prescription(
      {required this.rank, required this.text, required this.onTap});
}

class LabTests {
  final int id;
  final String name;
  final String description;
  final String testNotes;
  final Function() onTap;

  const LabTests(
      {required this.id,
      required this.name,
      required this.description,
      required this.testNotes,
      required this.onTap});
}
