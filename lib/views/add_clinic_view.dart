import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_clinic_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_clinic_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';
import 'package:medicory/widgets/enable_radiobutton_widget.dart';

class AddClinicView extends StatefulWidget {
  const AddClinicView({Key? key});

  @override
  State<AddClinicView> createState() => _AddClinicViewState();
}

class _AddClinicViewState extends State<AddClinicView> {
  String? valueChooseRole;
  bool? valueChooseEnabled;

  String? name,
      googleMapsLink,
      address,
      ownerName,
      specialization,
      email,
      phone;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Clinic",
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
                        onchange: (data) => setState(() => ownerName = data),
                        Label: "Owner Name :",
                        hintText: "Owner Name",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) =>
                            setState(() => specialization = data),
                        Label: "Specialization :",
                        hintText: "Specialization",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) => setState(() => email = data),
                        Label: "Email :",
                        hintText: "Email",
                      ),
                    ),
                    CustomDropdownButton(
                      addDropdownButton: AddDropdownButton(
                          label: "Role :",
                          hint: "Select Role",
                          items: [
                            "HOSPITAL",
                            "CLINIC",
                            "PHARMACY",
                            "LAB",
                            "OWNER",
                            "ADMIN",
                            "DOCTOR",
                            "EMERGENCY"
                          ],
                          value: valueChooseRole,
                          onChanged: (data) {
                            setState(() {
                              valueChooseRole = data;
                            });
                          }),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        onchange: (data) => setState(() => phone = data),
                        Label: "User Phone :",
                        hintText: "User Phone",
                      ),
                    ),
                    EnableRadioRow(
                      valueChooseEnabled: valueChooseEnabled,
                      onChanged: (bool? value) {
                        setState(() {
                          valueChooseEnabled = value;
                        });
                      },
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
      final addClinicService = AddNewClinicService();
      final AddNewClinicModel clinic = await addClinicService.addNewClinic(
        name: name!,
        googleMapsLink: googleMapsLink!,
        address: address!,
        ownerName: ownerName!,
        specialization: specialization!,
        email: email!,
        role: valueChooseRole!,
        userPhoneNumbers: [phone!], // Pass the phone numbers as a list
        enabled: valueChooseEnabled!,
      );

      print("Clinic added successfully: $clinic");
    } catch (error) {
      print("Failed to add clinic: $error");
    }
  }
}
