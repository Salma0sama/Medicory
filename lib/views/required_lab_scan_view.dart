// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/models/prescription_model.dart';
// import 'package:testtt/views/scan_result_view.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'package:testtt/widgets/required_lab_list_widget.dart';
// import 'package:testtt/services/prescription_service.dart'; // Import your service class

// class RequiredLabScans extends StatefulWidget {
//   RequiredLabScans({Key? key, required this.prescriptionId});

//   final int prescriptionId;

//   @override
//   State<RequiredLabScans> createState() => _RequiredLabScansState();
// }

// class _RequiredLabScansState extends State<RequiredLabScans> {
//   late Prescriptions labPrescriptions;
//   List<GetLabScanModel> scan = [];
//   Map<int, bool> scanStatus = {};

//   @override
//   void initState() {
//     super.initState();
//     labPrescriptions = Prescriptions(Dio());
//     scanStatus = {};
//   }

//   void updateTestResultStatus(int id, bool status) {
//     setState(() {
//       scanStatus[id] = status;
//     });
//   }

//   Widget navigateToTestResultView(GetLabScanModel scan) {
//     return ScanResultView(
//       getLabScansModel: scan,
//       onScanResultUpdated: (bool status) {
//         updateTestResultStatus(scan.id, status);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     String url =
//         "http://10.0.2.2:8081/lab/imagingTests/${widget.prescriptionId}";
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Required Scans",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: FutureBuilder<List<GetLabScanModel>>(
//         future: labPrescriptions.getLabScans(url),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           } else {
//             final prescriptions = snapshot.data!;
//             scanStatus = Map.fromIterable(prescriptions,
//                 key: (scanItem) => scanItem.id, value: (_) => false);

//             return ListView.builder(
//               itemCount: prescriptions.length,
//               itemBuilder: (context, index) {
//                 final prescription = prescriptions[index];
//                 bool testResultAvailable =
//                     determineTestResultAvailability(prescription);

//                 // Determine the background color based on testResult and status
//                 Color backgroundColor;
//                 if (prescription.imageResult == null &&
//                     scanStatus[prescription.id] == true) {
//                   backgroundColor = Colors.blue;
//                 } else if (prescription.imageResult != null &&
//                     scanStatus[prescription.id] == false) {
//                   backgroundColor = Colors.blue.withOpacity(0.5);
//                 } else {
//                   backgroundColor = Colors.transparent;
//                 }

//                 bool showIcon = prescription.imageResult == null ||
//                     scanStatus[prescription.id] == true; // Adjusted condition

//                 return RequiredLabLists(
//                   labTests: LabTests(
//                     id: prescription.id,
//                     name: prescription.name,
//                     testNotes: prescription.resultNotes,
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
//                   showIcon:
//                       showIcon, // Pass showIcon to control icon visibility
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   bool determineTestResultAvailability(GetLabScanModel prescription) {
//     return prescription.imageResult != null;
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/prescription_service.dart';
import 'package:medicory/views/scan_result_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/required_lab_list_widget.dart';

class RequiredLabScans extends StatefulWidget {
  RequiredLabScans({Key? key, required this.prescriptionId});

  final int prescriptionId;

  @override
  State<RequiredLabScans> createState() => _RequiredLabScansState();
}

class _RequiredLabScansState extends State<RequiredLabScans> {
  late Prescriptions labPrescriptions;
  List<GetLabScanModel> scan = [];
  Map<int, bool> scanStatus = {};

  @override
  void initState() {
    super.initState();
    labPrescriptions = Prescriptions(Dio());
    scanStatus = {};
  }

  void updateTestResultStatus(int id, bool status) {
    setState(() {
      scanStatus[id] = status;
    });
  }

  Widget navigateToTestResultView(GetLabScanModel scan) {
    return ScanResultView(
      getLabScansModel: scan,
      onScanResultUpdated: (bool status) {
        updateTestResultStatus(scan.id, status);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String url =
        "http://10.0.2.2:8081/lab/imagingTests/${widget.prescriptionId}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Required Scans",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: FutureBuilder<List<GetLabScanModel>>(
        future: labPrescriptions.getLabScans(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final prescriptions = snapshot.data!;
            scanStatus = Map.fromIterable(prescriptions,
                key: (scanItem) => scanItem.id, value: (_) => false);

            return ListView.builder(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                bool testResultAvailable =
                    determineTestResultAvailability(prescription);

                // Determine the background color based on testResult and status
                Color backgroundColor;
                if (prescription.imageResult == null &&
                    scanStatus[prescription.id] == true) {
                  backgroundColor = Colors.blue;
                } else if (prescription.imageResult != null &&
                    scanStatus[prescription.id] == false) {
                  backgroundColor = Colors.blue.withOpacity(0.5);
                } else {
                  backgroundColor = Colors.transparent;
                }

                bool showIcon = prescription.imageResult == null ||
                    scanStatus[prescription.id] == true; // Adjusted condition

                return RequiredLabLists(
                  labTests: LabTests(
                    id: index + 1, // Adjust the displayed ID to start from 1
                    name: prescription.name,
                    testNotes: prescription.resultNotes,
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
                  showIcon:
                      showIcon, // Pass showIcon to control icon visibility
                );
              },
            );
          }
        },
      ),
    );
  }

  bool determineTestResultAvailability(GetLabScanModel prescription) {
    return prescription.imageResult != null;
  }
}
