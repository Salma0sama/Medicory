import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class RequiredLabLists extends StatelessWidget {
  final LabTests labTests;
  final bool showIcon; // Define showIcon as a named parameter

  const RequiredLabLists({
    Key? key,
    required this.labTests,
    required this.showIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        GestureDetector(
          onTap: labTests.onTap, // Use onTap function from labTests
          child: Container(
            decoration: BoxDecoration(
              color: labTests.testResultAvailable
                  ? kPrimaryColor.withOpacity(
                      0.5) // Default color when testResult is available
                  : kPrimaryColor, // Apply opacity when testResult is not available
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    labTests.id.toString(),
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(width: 1), // Adding space between text and divider
                  Container(
                    height: 50, // You can adjust the height as needed
                    child: VerticalDivider(
                      color: Colors.white,
                      thickness: 1.2,
                      indent: 9,
                      endIndent: 9,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labTests.name,
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showIcon) // Conditionally show the icon based on showIcon
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.upload_file,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
