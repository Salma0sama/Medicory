import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/services/prescription_service.dart';
import 'package:medicory/views/lab_prescription_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/home_list_widget.dart';

class LabHomeView extends StatelessWidget {
  LabHomeView({Key? key}) : super(key: key);

  final String url = "http://10.0.2.2:8081/lab/prescriptions/91B39A22FA1447E9";
  final Prescriptions labPrescriptions = Prescriptions(Dio());

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
          SizedBox(
            height: 45,
          ),
          CircleAvatar(
            radius: 90,
            backgroundColor: kPrimaryColor,
            child: CircleAvatar(
              radius: 89,
              backgroundImage: AssetImage("lib/images/medicory2.jpg"),
            ),
          ),
          SizedBox(
            height: 5,
          ),
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
          SizedBox(
            height: 35,
          ),
          Expanded(
            child: FutureBuilder<List<GetPrescriptionModel>>(
              future: labPrescriptions.getPrescriptions(url),
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
                  final prescriptions = snapshot.data!;
                  return ListView.builder(
                    itemCount: prescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = prescriptions[index];
                      final formattedDate =
                          "${prescription.createdAt.day.toString().padLeft(2, '0')}-${prescription.createdAt.month.toString().padLeft(2, '0')}-${prescription.createdAt.year}";

                      return SingleChildScrollView(
                        child: HomeList(
                          prescription: Prescription(
                            rank: index + 1, // Start ID from 1
                            text: formattedDate,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LabPrescriptionView(
                                    prescriptionID: prescription.prescriptionId,
                                  ),
                                ),
                              );
                            },
                          ),
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
