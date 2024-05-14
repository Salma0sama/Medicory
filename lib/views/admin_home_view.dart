import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/views/admin_categories_view.dart';
import 'package:medicory/views/card_owner_categories_view.dart';
import 'package:medicory/views/clinic_categories_view.dart';
import 'package:medicory/views/doctor_categories_view.dart';
import 'package:medicory/views/hospital_categories_view.dart';
import 'package:medicory/views/lab_categories_view.dart';
import 'package:medicory/views/pharmacy_categories_view.dart';
import 'package:medicory/widgets/categories_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class AdminHomeView extends StatelessWidget {
  AdminHomeView({super.key});

  final List<ButtonDetails> categories = [
    ButtonDetails(Navigation: () => AdminCategoriesView(), Text: "Admins"),
    ButtonDetails(
        Navigation: () => CardOwnerCategoriesView(), Text: "Card Owners"),
    ButtonDetails(Navigation: () => ClinicCategoriesView(), Text: "Clinics"),
    ButtonDetails(
        Navigation: () => HospitalCategoriesView(), Text: "Hospitals"),
    ButtonDetails(
        Navigation: () => PharmacyCategoriesView(), Text: "Pharmacies"),
    ButtonDetails(Navigation: () => LabCategoriesView(), Text: "Labs"),
    ButtonDetails(Navigation: () => DoctorCategoriesView(), Text: "Doctors"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Home Page",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var category in categories) Categories(categories: category),
            ],
          ),
        ),
      ),
    );
  }
}
