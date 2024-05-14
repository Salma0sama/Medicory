import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/views/add_clinic_view.dart';
import 'package:medicory/views/search_clinic_view.dart';
import 'package:medicory/widgets/categories_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class ClinicCategoriesView extends StatelessWidget {
  ClinicCategoriesView({super.key});

  final List<ButtonDetails> categories = [
    ButtonDetails(Navigation: () => SearchClinicView(), Text: "Show Clinc"),
    ButtonDetails(Navigation: () => AddClinicView(), Text: "Add Clinic"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Clinics",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var category in categories) Categories(categories: category),
          ],
        ),
      ),
    );
  }
}
