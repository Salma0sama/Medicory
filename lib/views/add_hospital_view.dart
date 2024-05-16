import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_hospital_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_hospital_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';

class AddHospitalView extends StatefulWidget {
  const AddHospitalView({super.key});

  @override
  State<AddHospitalView> createState() => _AddHospitalViewState();
}

class _AddHospitalViewState extends State<AddHospitalView> {
  String? valueChooseRole;
  bool? valueChooseEnabled;

  String? name, googleMapsLink, address, email, phone;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Hospital",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) => setState(() => name = data),
                        Label: "Name :",
                        hintText: "Name",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) =>
                            setState(() => googleMapsLink = data),
                        Label: "Google Maps Link :",
                        hintText: "Google Maps Link",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) => setState(() => address = data),
                        Label: "Address :",
                        hintText: "Address",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) => setState(() => email = data),
                        Label: "Email :",
                        hintText: "Email",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) => setState(() => phone = data),
                        Label: "User Phone :",
                        hintText: "User Phone",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Button(
                      text: "Submit",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          submitData(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submitData(BuildContext context) async {
    try {
      final addHospitalService = AddNewHospitalService();
      final AddNewHospitalModel clinic =
          await addHospitalService.addNewHospital(
        name: name!,
        googleMapsLink: googleMapsLink!,
        address: address!,
        email: email!,
        role: "HOSPITAL",
        userPhoneNumbers: [phone!], // Pass the phone numbers as a list
        enabled: true,
      );

      print("Hospital added successfully: $clinic");
    } catch (error) {
      print("Failed to add Hospital: $error");
    }
  }
}
