import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class RequiredLabLists extends StatelessWidget {
  const RequiredLabLists({super.key, required this.labTests});
  final LabTests labTests;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1,
        ),
        Container(
          height: 110,
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  labTests.id.toString(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labTests.name,
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        labTests.description,
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 19,
                        ),
                      ),
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Notes : ",
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            labTests.testNotes,
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                IconButton(
                  onPressed: labTests.onTap,
                  icon: Icon(
                    Icons.upload_file,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
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
