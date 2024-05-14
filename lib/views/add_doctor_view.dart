import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_doctor_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_doctor_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';
import 'package:medicory/widgets/enable_radiobutton_widget.dart';

class AddDoctorView extends StatefulWidget {
  const AddDoctorView({super.key});

  @override
  State<AddDoctorView> createState() => _AddDoctorViewState();
}

class _AddDoctorViewState extends State<AddDoctorView> {
  String? valueChooseGender;
  String? valueChooseMaritalStatus;
  String? valueChooseRole;
  bool? valueChooseEnabled;

  String? firstName,
      middleName,
      lastName,
      specialization,
      licenceNumber,
      email,
      phone;

  // int? nationalId;
  String? nationalId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Doctor",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) => setState(() => firstName = data),
                      Label: "First Name :",
                      hintText: "First Name",
                    ),
                  ),
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) => setState(() => middleName = data),
                      Label: "Middle Name :",
                      hintText: "Middle Name",
                    ),
                  ),
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) => setState(() => lastName = data),
                      Label: "Last Name :",
                      hintText: "Last Name",
                    ),
                  ),
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) => setState(() => specialization = data),
                      Label: "Specialization :",
                      hintText: "Specialization",
                    ),
                  ),
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) => setState(() => licenceNumber = data),
                      Label: "LicenceNumber :",
                      hintText: "licenceNumbericenceNumber",
                    ),
                  ),
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) =>
                          setState(() => nationalId = //int.tryParse(data)
                              data),
                      Label: "National ID :",
                      hintText: "National ID",
                    ),
                  ),
                  CustomDropdownButton(
                    addDropdownButton: AddDropdownButton(
                        label: "Marital Status :",
                        hint: "Select Marital Status",
                        items: ["SINGLE", "MARRIED", "DIVORCED", "WIDOWED"],
                        value: valueChooseMaritalStatus,
                        onChanged: (data) {
                          setState(() {
                            valueChooseMaritalStatus = data;
                          });
                        }),
                  ),
                  CustomDropdownButton(
                    addDropdownButton: AddDropdownButton(
                        label: "Gender :",
                        hint: "Select Gender",
                        items: ["MALE", "FEMALE"],
                        value: valueChooseGender,
                        onChanged: (data) {
                          setState(() {
                            valueChooseGender = data;
                          });
                        }),
                  ),
                  CustomTextField(
                    addTextField: AddTextField(
                      onchange: (data) => setState(() => email = data),
                      Label: "User Email :",
                      hintText: "User Email",
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
    );
  }

  void submitData(BuildContext context) async {
    try {
      final addDoctorService = AddNewDoctorService();
      AddNewDoctorModel owner = await addDoctorService.addNewDoctor(
        firstName: firstName!,
        middleName: middleName!,
        lastName: lastName!,
        specialization: specialization!,
        licenceNumber: licenceNumber!,
        nationalId: nationalId!,
        maritalStatus: valueChooseMaritalStatus!,
        gender: valueChooseGender!,
        email: email!,
        role: valueChooseRole!,
        userPhoneNumbers: [phone!],
        enabled: valueChooseEnabled!,
      );
      print("Doctor added successfully: $owner");
    } catch (error) {
      print("Failed to add doctor: $error");
    }
  }
}
