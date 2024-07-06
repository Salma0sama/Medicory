// import 'package:flutter/material.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/views/required_lab_scan_view.dart';
// import 'package:testtt/views/required_lab_tests_view.dart';
// import 'package:testtt/widgets/admin_home_categories_widget.dart';
// import 'package:testtt/widgets/constants.dart';

// class LabPrescriptionView extends StatefulWidget {
//   final int prescriptionID;

//   LabPrescriptionView({Key? key, required this.prescriptionID})
//       : super(key: key);

//   @override
//   State<LabPrescriptionView> createState() => _LabPrescriptionViewState();
// }

// class _LabPrescriptionViewState extends State<LabPrescriptionView> {
//   bool imagesLoaded = false;
//   late List<ImageCategories> categories;

//   @override
//   void initState() {
//     super.initState();
//     categories = [
//       ImageCategories(
//         categoryName: "Required Tests",
//         image: "lib/images/test.jpg",
//         Navigation: () =>
//             RequiredLabTests(prescriptionId: widget.prescriptionID),
//       ),
//       ImageCategories(
//         categoryName: "Required Scans",
//         image: "lib/images/imaging.jpg",
//         Navigation: () =>
//             RequiredLabScans(prescriptionId: widget.prescriptionID),
//       ),
//     ];
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadImages(context);
//   }

//   Future<void> _loadImages(BuildContext context) async {
//     await Future.wait([
//       precacheImage(AssetImage("lib/images/test.jpg"), context),
//       precacheImage(AssetImage("lib/images/imaging.jpg"), context),
//     ]);
//     if (mounted) {
//       setState(() {
//         imagesLoaded = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Prescription Details",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: !imagesLoaded
//           ? Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: categories
//                   .map((category) => Padding(
//                         padding: const EdgeInsets.only(
//                             bottom: 20, left: 20, right: 20),
//                         child: AdminHomeCategories(categories: category),
//                       ))
//                   .toList(),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/prescription_service.dart';
import 'package:medicory/views/required_lab_scan_view.dart';
import 'package:medicory/views/required_lab_tests_view.dart';
import 'package:medicory/widgets/admin_home_categories_widget.dart';
import 'package:medicory/widgets/constants.dart';

class LabPrescriptionView extends StatefulWidget {
  final int prescriptionID;

  LabPrescriptionView({Key? key, required this.prescriptionID})
      : super(key: key);

  @override
  State<LabPrescriptionView> createState() => _LabPrescriptionViewState();
}

class _LabPrescriptionViewState extends State<LabPrescriptionView> {
  bool imagesLoaded = false;
  late List<ImageCategories> categories;
  late Prescriptions labPrescriptions;

  @override
  void initState() {
    super.initState();
    labPrescriptions = Prescriptions(Dio());

    categories = [
      ImageCategories(
        categoryName: "Required Tests",
        image: "lib/images/test.jpg",
        Navigation: () =>
            RequiredLabTests(prescriptionId: widget.prescriptionID),
      ),
      ImageCategories(
        categoryName: "Required Scans",
        image: "lib/images/imaging.jpg",
        Navigation: () =>
            RequiredLabScans(prescriptionId: widget.prescriptionID),
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages(context);
  }

  Future<void> _loadImages(BuildContext context) async {
    await Future.wait([
      precacheImage(AssetImage("lib/images/test.jpg"), context),
      precacheImage(AssetImage("lib/images/imaging.jpg"), context),
    ]);
    if (mounted) {
      setState(() {
        imagesLoaded = true;
      });
    }
  }

  Future<Map<String, bool>> fetchData() async {
    String testsUrl = "http://10.0.2.2:8081/lab/tests/${widget.prescriptionID}";
    String scansUrl =
        "http://10.0.2.2:8081/lab/imagingTests/${widget.prescriptionID}";

    final testsFuture = labPrescriptions.getLabTests(testsUrl);
    final scansFuture = labPrescriptions.getLabScans(scansUrl);

    final tests = await testsFuture;
    final scans = await scansFuture;

    return {
      "hasTests": tests.isNotEmpty,
      "hasScans": scans.isNotEmpty,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Prescription Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: !imagesLoaded
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, bool>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final hasTests = data["hasTests"] ?? false;
                  final hasScans = data["hasScans"] ?? false;

                  List<ImageCategories> displayedCategories = [];

                  if (hasTests) {
                    displayedCategories.add(categories[0]);
                  }
                  if (hasScans) {
                    displayedCategories.add(categories[1]);
                  }

                  if (displayedCategories.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: displayedCategories
                        .map((category) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20),
                              child: AdminHomeCategories(categories: category),
                            ))
                        .toList(),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
    );
  }
}
