import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/lab_prescription_service.dart';
import 'package:medicory/views/lab_home_view.dart';
import 'package:medicory/views/required_lab_tests_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/prescription_list_widget.dart';

class LabPrescriptionView extends StatelessWidget {
  LabPrescriptionView({Key? key});

  final String url = "http://10.0.2.2:8081/lab/prescriptions/391A18DD1A1C42C0";
  final LabPrescriptions labPrescriptions = LabPrescriptions(Dio());
  final List<ButtonDetails> categories = [
    ButtonDetails(Navigation: () => RequiredLabTests(), Text: "Required Tests"),
    ButtonDetails(Navigation: () => LabHomeView(), Text: "Required Scans"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<GetPrescriptionDetailsModel>>(
            future: labPrescriptions.getLabPrescriptionDetails(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final prescription = snapshot.data!.first;
                final formattedDate =
                    "${prescription.createdAt.year}-${prescription.createdAt.month.toString().padLeft(2, '0')}-${prescription.createdAt.day.toString().padLeft(2, '0')}";

                final List<RowData> rowData = [
                  RowData(
                      label: "Doctor Name : ",
                      value: prescription.doctorName ?? "................."),
                  RowData(label: "Date : ", value: formattedDate),
                ];

                return Padding(
                  padding: const EdgeInsets.only(top: 65, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var data in rowData) BuildRow(rowData: data),
                      BuildDivider(),
                      BuildRow(
                        rowData: RowData(
                            label: "R ",
                            value: "/ ___________________________________"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: [
                            for (var category in categories)
                              PrescriptionList(buttonDetails: category),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
