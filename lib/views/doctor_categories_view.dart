import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/views/add_doctor_view.dart';
import 'package:medicory/views/search_doctor_view.dart';
import 'package:medicory/widgets/categories_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class DoctorCategoriesView extends StatelessWidget {
  DoctorCategoriesView({super.key});

  final List<ButtonDetails> categories = [
    ButtonDetails(Navigation: () => SearchDoctorView(), Text: "Show Doctor"),
    ButtonDetails(Navigation: () => AddDoctorView(), Text: "Add Doctor"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Doctors",
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
