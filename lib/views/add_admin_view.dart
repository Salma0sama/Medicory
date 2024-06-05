import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_admin_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddAdminView extends StatefulWidget {
  const AddAdminView({Key? key}) : super(key: key);

  @override
  State<AddAdminView> createState() => _AddAdminViewState();
}

class _AddAdminViewState extends State<AddAdminView> {
  String? valueChooseGender;
  String? valueChooseMaritalStatus;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clearFields() {
    setState(() {
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      phoneController.clear();
      valueChooseMaritalStatus = null;
      valueChooseGender = null;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        controller: firstNameController,
                        onUpdate: (data) {},
                        label: "First Name :",
                        hintText: "First Name",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        controller: lastNameController,
                        onUpdate: (data) {},
                        label: "Last Name :",
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
                        },
                      ),
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
                        },
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        controller: emailController,
                        onUpdate: (data) {},
                        label: "User Email :",
                        hintText: "User Email",
                      ),
                    ),
                    CustomTextField(
                      addTextField: AddTextField(
                        controller: phoneController,
                        onUpdate: (data) {},
                        label: "User Phone :",
                        hintText: "User Phone",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Button(
                      text: "Submit",
                      onPressed: () async {
                        isLoading = true;
                        setState(() {});
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            final addAdminService = AddNewAdminService();
                            final success = await addAdminService.addNewAdmin(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              maritalStatus: valueChooseMaritalStatus!,
                              gender: valueChooseGender!,
                              email: emailController.text,
                              role: "ADMIN",
                              userPhoneNumbers: [phoneController.text],
                              enabled: true,
                            );
                            if (success) {
                              print("Admin added successfully");
                              clearFields();
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Success',
                                  message: 'Admin added successfully',
                                  contentType: ContentType.success,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            }
                          } catch (error) {
                            print("Failed to add Admin: $error");
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Error',
                                message:
                                    'Failed to add Admin: Make sure you entered all fields}',
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                            if (error is Exception) {
                              final errorMessage = error.toString();
                              if (errorMessage.contains("409") &&
                                  errorMessage.contains("This phone number") &&
                                  errorMessage.contains("already exists")) {
                                // Handle the case where phone number already exists
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error',
                                    message: 'Phone number already exists',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              } else if (errorMessage.contains("409") &&
                                  errorMessage.contains("User Email") &&
                                  errorMessage.contains("already exists")) {
                                // Handle the case where email already exists
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error',
                                    message: 'User email already exists',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            }
                          }
                        }
                        isLoading = false;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
