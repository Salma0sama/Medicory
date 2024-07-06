// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/models/prescription_model.dart';
// import 'package:testtt/views/test_result_view.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'package:testtt/widgets/required_lab_list_widget.dart';
// import 'package:testtt/services/prescription_service.dart';

// class RequiredLabTests extends StatefulWidget {
//   RequiredLabTests({Key? key, required this.prescriptionId}) : super(key: key);

//   final int prescriptionId;

//   @override
//   State<RequiredLabTests> createState() => _RequiredLabTestsState();
// }

// class _RequiredLabTestsState extends State<RequiredLabTests> {
//   late Prescriptions labPrescriptions;
//   List<GetLabTestsModel> test = [];
//   Map<int, bool> testStatus = {};

//   @override
//   void initState() {
//     super.initState();
//     labPrescriptions = Prescriptions(Dio());
//     testStatus = {};
//   }

//   void updateTestResultStatus(int id, bool status) {
//     setState(() {
//       testStatus[id] = status;
//     });
//   }

//   Widget navigateToTestResultView(GetLabTestsModel test) {
//     return TestResultView(
//       getLabTestsModel: test,
//       onTestResultUpdated: (bool status) {
//         updateTestResultStatus(test.id, status);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     String url = "http://10.0.2.2:8081/lab/tests/${widget.prescriptionId}";
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Required Tests",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: FutureBuilder<List<GetLabTestsModel>>(
//         future: labPrescriptions.getLabTests(url),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           } else {
//             final prescriptions = snapshot.data!;
//             testStatus = Map.fromIterable(prescriptions,
//                 key: (testItem) => testItem.id, value: (_) => false);

//             return ListView.builder(
//               itemCount: prescriptions.length,
//               itemBuilder: (context, index) {
//                 final prescription = prescriptions[index];
//                 bool testResultAvailable =
//                     determineTestResultAvailability(prescription);

//                 // Determine the background color based on testResult and status
//                 Color backgroundColor;
//                 if (prescription.testResult == null &&
//                     testStatus[prescription.id] == true) {
//                   backgroundColor = Colors.blue;
//                 } else if (prescription.testResult != null &&
//                     testStatus[prescription.id] == false) {
//                   backgroundColor = Colors.blue.withOpacity(0.5);
//                 } else {
//                   backgroundColor = Colors.transparent;
//                 }

//                 bool showIcon = prescription.testResult == null ||
//                     testStatus[prescription.id] == true;

//                 return RequiredLabLists(
//                   labTests: LabTests(
//                     id: prescription.id,
//                     name: prescription.name,
//                     testNotes: prescription.testNotes,
//                     testResultAvailable: testResultAvailable,
//                     onTap: () async {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               navigateToTestResultView(prescription),
//                         ),
//                       );
//                     },
//                     backgroundColor: backgroundColor,
//                   ),
//                   showIcon: showIcon,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   bool determineTestResultAvailability(GetLabTestsModel prescription) {
//     return prescription.testResult != null;
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/prescription_service.dart';
import 'package:medicory/views/test_result_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/required_lab_list_widget.dart';

class RequiredLabTests extends StatefulWidget {
  RequiredLabTests({Key? key, required this.prescriptionId}) : super(key: key);

  final int prescriptionId;

  @override
  State<RequiredLabTests> createState() => _RequiredLabTestsState();
}

class _RequiredLabTestsState extends State<RequiredLabTests> {
  late Prescriptions labPrescriptions;
  Map<int, bool> testStatus = {};

  @override
  void initState() {
    super.initState();
    labPrescriptions = Prescriptions(Dio());
  }

  void updateTestResultStatus(int id, bool status) {
    setState(() {
      testStatus[id] = status;
    });
  }

  Widget navigateToTestResultView(GetLabTestsModel test) {
    return TestResultView(
      getLabTestsModel: test,
      onTestResultUpdated: (bool status) {
        updateTestResultStatus(test.id, status);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String url = "http://10.0.2.2:8081/lab/tests/${widget.prescriptionId}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Required Tests",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: FutureBuilder<List<GetLabTestsModel>>(
        future: labPrescriptions.getLabTests(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final prescriptions = snapshot.data!;
            testStatus = {
              for (var prescription in prescriptions) prescription.id: false
            };

            return ListView.builder(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                bool testResultAvailable =
                    determineTestResultAvailability(prescription);

                // Determine the background color based on testResult and status
                Color backgroundColor;
                if (prescription.testResult == null &&
                    testStatus[prescription.id] == true) {
                  backgroundColor = Colors.blue;
                } else if (prescription.testResult != null &&
                    testStatus[prescription.id] == false) {
                  backgroundColor = Colors.blue.withOpacity(0.5);
                } else {
                  backgroundColor = Colors.transparent;
                }

                bool showIcon = prescription.testResult == null ||
                    testStatus[prescription.id] == true;

                return RequiredLabLists(
                  labTests: LabTests(
                    id: index + 1, // Adjust the displayed ID to start from 1
                    name: prescription.name,
                    testNotes: prescription.testNotes,
                    testResultAvailable: testResultAvailable,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              navigateToTestResultView(prescription),
                        ),
                      );
                    },
                    backgroundColor: backgroundColor,
                  ),
                  showIcon: showIcon,
                );
              },
            );
          }
        },
      ),
    );
  }

  bool determineTestResultAvailability(GetLabTestsModel prescription) {
    return prescription.testResult != null;
  }
}
