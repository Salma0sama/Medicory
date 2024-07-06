import 'package:flutter/material.dart';
import 'package:medicory/models/medication_model.dart';
import 'package:medicory/widgets/constants.dart';

class MedicinesList extends StatelessWidget {
  const MedicinesList({
    Key? key,
    required this.prescription,
    required this.onTap,
  }) : super(key: key);

  final Medication prescription;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 55,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kPrimaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    prescription.id.toString(),
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 18,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 1.2,
                    indent: 13,
                    endIndent: 13,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          prescription.name,
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
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
