import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_doctor_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_add_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_add_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddDoctorView extends StatefulWidget {
  const AddDoctorView({super.key});

  @override
  State<AddDoctorView> createState() => _AddDoctorViewState();
}

class _AddDoctorViewState extends State<AddDoctorView> {
  String? valueChooseGender;
  String? valueChooseMaritalStatus;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController licenceNumberController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool imagesLoaded = false;

  void clearFields() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    specializationController.clear();
    licenceNumberController.clear();
    nationalIdController.clear();
    emailController.clear();
    phoneController.clear();
    setState(() {
      valueChooseMaritalStatus = null;
      valueChooseGender = null;
    });
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final addDoctorService = AddNewDoctorService();
      final success = await addDoctorService.addNewDoctor(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text,
        specialization: specializationController.text,
        licenceNumber: licenceNumberController.text,
        nationalId: nationalIdController.text,
        maritalStatus: valueChooseMaritalStatus!,
        gender: valueChooseGender!,
        email: emailController.text,
        role: "DOCTOR",
        userPhoneNumbers: [phoneController.text],
        enabled: true,
      );
      if (success) {
        clearFields();
        _showSnackBar(
          title: 'Success',
          message: 'Doctor added successfully',
          contentType: ContentType.success,
        );
      }
    } catch (error) {
      _handleError(error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _handleError(Object error) {
    print("Failed to add Doctor: $error");

    if (error is Exception) {
      final errorMessage = error.toString();

      if (errorMessage.contains("409")) {
        if (errorMessage.contains("This phone number ") &&
            errorMessage.contains(" already exist")) {
          _showSnackBar(
            title: 'Error',
            message: 'Phone number already exists',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("User with this email ") &&
            errorMessage.contains(" already exist ")) {
          _showSnackBar(
            title: 'Error',
            message: 'User email already exists',
            contentType: ContentType.failure,
          );
        }
      } else if (errorMessage.contains("400")) {
        if (errorMessage.contains("firstName") &&
            errorMessage
                .contains("First name must be between 2 and 50 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'First name must be between 2 and 50 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("lastName") &&
            errorMessage
                .contains("Last name must be between 2 and 50 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Last name must be between 2 and 50 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("specialization") &&
            errorMessage.contains(
                "Specialization must be between 3 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Specialization must be between 3 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("licenceNumber") &&
            errorMessage.contains(
                "Licence number must contain only uppercase letters, numbers, and dashes")) {
          _showSnackBar(
            title: 'Error',
            message:
                'Licence number must contain only uppercase letters, numbers, and dashes',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("nationalId") &&
            errorMessage.contains("National ID must be exactly 14 digits")) {
          _showSnackBar(
            title: 'Error',
            message: 'National ID must be exactly 14 digits',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("is required")) {
          _showSnackBar(
            title: 'Error',
            message: 'Make sure you entered all fields',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("email") &&
            errorMessage.contains("Invalid email format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid email format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("userPhoneNumbers[0]") &&
            errorMessage.contains("Invalid phone number format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid phone number format',
            contentType: ContentType.failure,
          );
        }
      }
    } else {
      _showSnackBar(
        title: 'Error',
        message: 'Failed to add Doctor: Make sure you entered all fields',
        contentType: ContentType.failure,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages(context);
  }

  Future<void> _loadImages(BuildContext context) async {
    await Future.wait([
      precacheImage(AssetImage("lib/icons/badge.png"), context),
      precacheImage(AssetImage("lib/icons/gender.png"), context),
      precacheImage(AssetImage("lib/icons/couple.png"), context),
      precacheImage(AssetImage("lib/icons/diploma (1).png"), context),
      precacheImage(AssetImage("lib/icons/id-card1.png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Doctor",
          style: TextStyle(color: kTextColor),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: !imagesLoaded
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: firstNameController,
                            label: "First Name",
                            hintText: "Enter First Name",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.person,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: middleNameController,
                            label: "Middle Name *",
                            hintText: "Enter Middle Name (Optional)",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.person,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: lastNameController,
                            label: "Last Name",
                            hintText: "Enter Last Name",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.person,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: specializationController,
                            label: "Specialization",
                            hintText: "Enter Specialization",
                            prefixIcon: (bool isFocused) {
                              return Image.asset(
                                "lib/icons/badge.png",
                                height: 25,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: licenceNumberController,
                            label: "Licence Number",
                            hintText: "Enter Licence Number",
                            prefixIcon: (bool isFocused) {
                              return Image.asset(
                                "lib/icons/diploma (1).png",
                                height: 25,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            keyboardType: TextInputType.number,
                            controller: nationalIdController,
                            label: "National ID",
                            hintText: "Enter National ID",
                            prefixIcon: (bool isFocused) {
                              return Image.asset(
                                "lib/icons/id-card1.png",
                                height: 25,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomDropdownButton(
                          addDropdownButton: AddDropdownButton(
                            label: "Marital Status",
                            hint: "Select Marital Status",
                            items: ["SINGLE", "MARRIED", "DIVORCED", "WIDOWED"],
                            value: valueChooseMaritalStatus,
                            onChanged: (data) {
                              setState(() {
                                valueChooseMaritalStatus = data;
                              });
                            },
                            prefixIcon: (isFocused) => Image.asset(
                              "lib/icons/couple.png",
                              height: 25,
                              color: isFocused ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                        CustomDropdownButton(
                          addDropdownButton: AddDropdownButton(
                            label: "Gender",
                            hint: "Select Gender",
                            items: ["MALE", "FEMALE"],
                            value: valueChooseGender,
                            onChanged: (data) {
                              setState(() {
                                valueChooseGender = data;
                              });
                            },
                            prefixIcon: (isFocused) => Image.asset(
                              "lib/icons/gender.png",
                              height: 25,
                              color: isFocused ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: emailController,
                            label: "Email",
                            hintText: "Enter Email",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.email,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: phoneController,
                            label: "Phone",
                            hintText: "Enter Phone",
                            keyboardType: TextInputType.number,
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.phone_android,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              text: "Submit",
                              onPressed: handleSubmit,
                            ),
                            SizedBox(width: 35),
                            Button(
                              text: "Clear",
                              onPressed: clearFields,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
