import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class PrescriptionList extends StatefulWidget {
  const PrescriptionList({super.key, required this.buttonDetails});
  final ButtonDetails buttonDetails;

  @override
  State<PrescriptionList> createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return widget.buttonDetails.Navigation();
                    },
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: kPrimaryColor,
            minimumSize: const Size(210, 55),
          ),
          child: Text(
            widget.buttonDetails.Text,
            style: TextStyle(
              color: kTextColor,
              fontSize: 19,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
