// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:medicory/models/general_model.dart';
// import 'package:medicory/models/prescription_model.dart';
// import 'package:medicory/services/lab_prescription_service.dart';
// import 'package:medicory/widgets/constants.dart';
// import 'package:medicory/widgets/required_lab_list_widget.dart';

// class RequiredLabTests extends StatelessWidget {
//   RequiredLabTests({super.key});

//   final String url = "http://10.0.2.2:8081/lab/tests/1";
//   final LabPrescriptions labPrescriptions = LabPrescriptions(Dio());

//   @override
//   Widget build(BuildContext context) {
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
//           } else {
//             final prescriptions = snapshot.data!;
//             return ListView.builder(
//               itemCount: prescriptions.length,
//               itemBuilder: (context, index) {
//                 final prescription = prescriptions[index];

//                 return RequiredLabLists(
//                     labTests: LabTests(
//                         id: prescription.id,
//                         name: prescription.name,
//                         description: prescription.description,
//                         testNotes: prescription.testNotes,
//                         onTap: () async {
//                           final result = await FilePicker.platform.pickFiles();
//                           if (result == null) return;

//                           final file = result.files.first;
//                           openFile(file);
//                         }));
//                 // HomeList(
//                 //   prescription: Prescription(
//                 //     rank: prescription.prescriptionId,
//                 //     text: formattedDate,
//                 //     onTap: () {
//                 //       Navigator.push(
//                 //         context,
//                 //         MaterialPageRoute(
//                 //             builder: (context) => LabPrescriptionView()),
//                 //       );
//                 //     },
//                 //   ),
//                 // );
//               },
//             );
//           }
//         },
//       ),
//       // body: Column(
//       //   children: [
//       //     SizedBox(
//       //       height: 1,
//       //     ),
//       //     for (var data in rowData) RequiredLabLists(rowData: data),
//       //   ],
//       // ),
//     );
//     void openFile(PlatformFile file) {
//       openFile(file.path!);
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/lab_prescription_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/required_lab_list_widget.dart';

class RequiredLabTests extends StatelessWidget {
  RequiredLabTests({super.key});

  final String url = "http://10.0.2.2:8081/lab/tests/2";
  final LabPrescriptions labPrescriptions = LabPrescriptions(Dio());

  @override
  Widget build(BuildContext context) {
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
          } else {
            final prescriptions = snapshot.data!;
            return ListView.builder(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];

                return RequiredLabLists(
                  labTests: LabTests(
                    id: prescription.id,
                    name: prescription.name,
                    description: prescription.description,
                    testNotes: prescription.testNotes,
                    onTap: () async {
                      // final result = await FilePicker.platform.pickFiles();
                      // if (result == null) return;

                      // final file = result.files.first;
                      // openFile(file.path!); // Pass the file path as a String
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // void openFile(String filePath) {
  //   // Implement file opening functionality here
  // }
}
