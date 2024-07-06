import 'package:flutter/material.dart';

class ButtonDetails {
  final String Text;
  final Function() Navigation;
  const ButtonDetails({required this.Navigation, required this.Text});
}

class AddTextField {
  final String label;
  final String hintText;
  final Widget Function(bool isFocused) prefixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  AddTextField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.controller,
  });
}

class AddDropdownButton {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final Widget Function(bool isFocused)? prefixIcon; // Made optional

  const AddDropdownButton({
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.prefixIcon, // Made optional
  });
}

class RowData {
  final String label;
  final dynamic value;

  const RowData({required this.label, required this.value});
}

class ImageCategories {
  final String image;
  final String categoryName;
  final Widget Function() Navigation;

  const ImageCategories(
      {required this.categoryName,
      required this.image,
      required this.Navigation});
}

class ShowContainer {
  final IconData icon;
  final String label;
  final String value;

  const ShowContainer(
      {required this.icon, required this.label, required this.value});
}

class InfoContainer {
  final int id;
  final String fullName;
  final Color containerColor;
  final Widget? icon; // Optional icon widget

  InfoContainer({
    required this.id,
    required this.fullName,
    required this.containerColor,
    this.icon, // Initialize if needed
  });
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
  final String testNotes;
  final bool testResultAvailable; // Indicates if test result is available
  final VoidCallback onTap; // Function to handle onTap event
  final Color? backgroundColor; // Optional background color
  final bool status; // Status to indicate if test result is uploaded

  LabTests({
    required this.id,
    required this.name,
    required this.testNotes,
    required this.testResultAvailable,
    required this.onTap,
    this.backgroundColor,
    this.status = false,
  });
}

class MedicationDetails {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final Function(dynamic) onchange;
  const MedicationDetails(
      {required this.label,
      this.controller,
      required this.hintText,
      required this.onchange});
}
