import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key, required this.prescription});
  final Prescription prescription;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1,
        ),
        GestureDetector(
          onTap: prescription.onTap,
          child: Container(
            height: 80,
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    prescription.rank.toString(),
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 19,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 1.2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          prescription.text,
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
