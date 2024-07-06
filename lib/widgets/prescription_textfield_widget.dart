import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class PrescriptionTextField extends StatefulWidget {
  const PrescriptionTextField({Key? key, required this.medicationDetails})
      : super(key: key);
  final MedicationDetails medicationDetails;

  @override
  _PrescriptionTextFieldState createState() => _PrescriptionTextFieldState();
}

class _PrescriptionTextFieldState extends State<PrescriptionTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.medicationDetails.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: kPrimaryColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        onChanged: (text) {
                          widget.medicationDetails.onchange(text);
                        },
                        controller: widget.medicationDetails.controller,
                        minLines: 1, // Minimum number of lines
                        maxLines: null, // Expands as needed
                        decoration: InputDecoration(
                          hintText: widget.medicationDetails.hintText,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
