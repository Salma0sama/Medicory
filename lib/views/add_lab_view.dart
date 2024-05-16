import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_lab_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_lab_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';

class AddLabView extends StatefulWidget {
  const AddLabView({super.key});

  @override
  State<AddLabView> createState() => _AddLabViewState();
}

class _AddLabViewState extends State<AddLabView> {
  String? valueChooseRole;
  bool? valueChooseEnabled;

  String? name, googleMapsLink, address, ownerName, email, phone;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Lab",
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
      final addLabService = AddNewLabService();
      final AddNewLabModel clinic = await addLabService.addNewLab(
        name: name!,
        googleMapsLink: googleMapsLink!,
        address: address!,
        ownerName: ownerName!,
        email: email!,
        role: "LAB",
        userPhoneNumbers: [phone!],
        enabled: true,
      );

      print("Lab added successfully: $clinic");
    } catch (error) {
      print("Failed to add lab: $error");
    }
  }
}
