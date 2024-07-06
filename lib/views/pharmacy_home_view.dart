import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/prescription_service.dart';
import 'package:medicory/views/pharmacy_prescription_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/home_list_widget.dart';

class PharmacyHomeView extends StatelessWidget {
  PharmacyHomeView({Key? key});

  final String url =
      "http://10.0.2.2:8081/pharmacy/prescriptions/91B39A22FA1447E9";
  final Prescriptions pharmacyPrescriptions = Prescriptions(Dio());

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
      body: Column(
        children: [
          SizedBox(height: 45),
          CircleAvatar(
            radius: 90,
            backgroundColor: kPrimaryColor,
            child: CircleAvatar(
              radius: 89,
              backgroundImage: AssetImage("lib/images/medicory2.jpg"),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "MEDICORY",
                style: TextStyle(
                  fontFamily: "Pacifico",
                  color: kPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Expanded(
            child: FutureBuilder<List<GetPrescriptionModel>>(
              future: pharmacyPrescriptions.getPrescriptions(url),
              builder: (context, snapshot) {
                print("Snapshot State: ${snapshot.connectionState}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(child: Text("Error loading prescriptions"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print("No prescriptions found");
                  return Center(child: Text("No prescriptions found"));
                } else {
                  // Sort prescriptions by createdAt in descending order
                  List<GetPrescriptionModel> prescriptions = snapshot.data!;
                  prescriptions
                      .sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  int prescriptionIdCounter =
                      1; // Start prescription IDs from 1

                  return ListView.builder(
                    itemCount: prescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = prescriptions[index];
                      final formattedDate =
                          "${prescription.createdAt.day.toString().padLeft(2, '0')}-${prescription.createdAt.month.toString().padLeft(2, '0')}-${prescription.createdAt.year}";

                      final int currentPrescriptionId = prescriptionIdCounter++;

                      return HomeList(
                        prescription: Prescription(
                          rank: currentPrescriptionId,
                          text: formattedDate,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PharmacyPrescriptionView(
                                  prescriptionId: prescription.prescriptionId,
                                  prescription: prescription,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
