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
      body: Padding(
        padding: const EdgeInsets.only(top: 45),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
              for (var category in categories) Categories(categories: category),
            ],
          ),
        ),
      ),
    );
  }
}
