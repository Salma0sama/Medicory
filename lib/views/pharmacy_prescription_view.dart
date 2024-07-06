import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/medication_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/prescription_service.dart';
import 'package:medicory/views/prescription_details_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/madicines_list_widget.dart';

class PharmacyPrescriptionView extends StatelessWidget {
  final GetPrescriptionModel prescription;
  final int prescriptionId;
  final Prescriptions prescriptionsService = Prescriptions(Dio());

  PharmacyPrescriptionView(
      {required this.prescription, required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        "${prescription.createdAt.day.toString().padLeft(2, '0')}-${prescription.createdAt.month.toString().padLeft(2, '0')}-${prescription.createdAt.year}";

    final String url =
        "http://10.0.2.2:8081/pharmacy/prescriptions/91B39A22FA1447E9/$prescriptionId/medications";
    final List<RowData> rowData = [
      RowData(label: "Patient Name : ", value: "Hossam Mohamed Nagy"),
      RowData(
        label: "Doctor Name : ",
        value: "Yousef Eslam Omara",
      ),
      RowData(label: "Date : ", value: formattedDate),
    ];

    int medicationIdCounter = 1; // Start medication IDs from 1

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Prescription",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: FutureBuilder<List<PrescriptionDetailsModel>>(
        future: prescriptionsService.getPrescriptionDetails(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No prescription details found"));
          } else {
            final List<Medication> medications = snapshot.data!
                .expand((details) => details.medications)
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var data in rowData) BuildRow(rowData: data),
                  BuildDivider(),
                  BuildRow(
                    rowData: RowData(
                      label: "R ",
                      value: "/ ______________________________________",
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: medications.map((medication) {
                      final int currentMedicationId = medicationIdCounter++;
                      return Center(
                        child: MedicinesList(
                          key: Key(currentMedicationId.toString()),
                          prescription: Medication(
                            id: currentMedicationId,
                            name: medication.name,
                            dose: medication.dose,
                            frequency: medication.frequency,
                            tips: medication.tips,
                            sideEffects: medication.sideEffects ?? '',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrescriptionDetailsView(
                                  medication: Medication(
                                    id: currentMedicationId,
                                    name: medication.name,
                                    dose: medication.dose,
                                    frequency: medication.frequency,
                                    tips: medication.tips,
                                    sideEffects: medication.sideEffects ?? '',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
