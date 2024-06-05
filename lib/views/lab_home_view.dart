import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/lab_prescription_service.dart';
import 'package:medicory/views/lab_prescription_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/home_list_widget.dart';

class LabHomeView extends StatelessWidget {
  LabHomeView({Key? key});

  final String url = "http://10.0.2.2:8081/lab/prescriptions/391A18DD1A1C42C0";
  final LabPrescriptions labPrescriptions = LabPrescriptions(Dio());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Prescriptions List",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: FutureBuilder<List<GetPrescriptionModel>>(
        future: labPrescriptions.getLabPrescriptions(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            final prescriptions = snapshot.data!;
            return ListView.builder(
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                final formattedDate =
                    "${prescription.createdAt.year}-${prescription.createdAt.month.toString().padLeft(2, '0')}-${prescription.createdAt.day.toString().padLeft(2, '0')}";

                return HomeList(
                  prescription: Prescription(
                    rank: prescription.prescriptionId,
                    text: formattedDate,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LabPrescriptionView()),
                      );
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
}