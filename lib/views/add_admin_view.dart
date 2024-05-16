import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_admin_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_admin_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';

class AddAdminView extends StatefulWidget {
  const AddAdminView({super.key});

  @override
  State<AddAdminView> createState() => _AddAdminViewState();
}

class _AddAdminViewState extends State<AddAdminView> {
  String? valueChooseGender;
  String? valueChooseMaritalStatus;
  String? valueChooseRole;
  bool? valueChooseEnabled;

  String? firstName, lastName, email, phone;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Admin",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Center(
        child: Padding(
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
                        onchange: (data) => setState(() => lastName = data),
                        Label: "Last Name :",
                        hintText: "Last Name",
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
      final addAdminService = AddNewAdminService();
      AddNewAdminModel admin = await addAdminService.addNewAdmin(
        firstName: firstName!,
        lastName: lastName!,
        maritalStatus: valueChooseMaritalStatus!,
        gender: valueChooseGender!,
        email: email!,
        role: "ADMIN",
        userPhoneNumbers: [phone!],
        enabled: true,
      );
      print("Admin added successfully: $admin");
    } catch (error) {
      print("Failed to add Admin: $error");
    }
  }
}
