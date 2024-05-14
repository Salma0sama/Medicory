import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/views/add_pharmacy_view.dart';
import 'package:medicory/views/search_pharmacy_view.dart';
import 'package:medicory/widgets/categories_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class PharmacyCategoriesView extends StatelessWidget {
  PharmacyCategoriesView({super.key});

  final List<ButtonDetails> categories = [
    ButtonDetails(
        Navigation: () => SearchPharmacyView(), Text: "Show Pharmacy"),
    ButtonDetails(Navigation: () => AddPharmacyView(), Text: "Add Pharmacy"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Pharmacies",
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
