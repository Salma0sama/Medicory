import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_admin_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_add_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_add_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddAdminView extends StatefulWidget {
  const AddAdminView({super.key});

  @override
  State<AddAdminView> createState() => _AddAdminViewState();
}

class _AddAdminViewState extends State<AddAdminView> {
  String? valueChooseGender;
  String? valueChooseMaritalStatus;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool imagesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages(context);
  }

  Future<void> _loadImages(BuildContext context) async {
    await Future.wait([
      precacheImage(AssetImage("lib/icons/couple.png"), context),
      precacheImage(AssetImage("lib/icons/gender.png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
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
        clearFields();
        _showSnackBar(
          title: 'Success',
          message: 'Admin added successfully',
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
    print("Failed to add Admin: $error");

    if (error is Exception) {
      final errorMessage = error.toString();

      if (errorMessage.contains("409")) {
        if (errorMessage.contains("This phone number") &&
            errorMessage.contains("already exists")) {
          _showSnackBar(
            title: 'Error',
            message: 'Phone number already exists',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("User Email") &&
            errorMessage.contains("already exists")) {
          _showSnackBar(
            title: 'Error',
            message: 'User email already exists',
            contentType: ContentType.failure,
          );
        }
      } else if (errorMessage.contains("400")) {
        if (errorMessage.contains("firstName") &&
            errorMessage
                .contains("First name must be between 3 and 15 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'First name must be between 3 and 15 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("lastName") &&
            errorMessage
                .contains("Last name must be between 3 and 15 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Last name must be between 3 and 15 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("email") &&
            errorMessage.contains("Invalid email format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid email format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("phoneNumbers[0]") &&
            errorMessage.contains("Invalid phone number format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid phone number format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("phoneNumbers[0]") &&
            errorMessage
                .contains("phone number can't be less than 8 or exceeded 11")) {
          _showSnackBar(
            title: 'Error',
            message: 'phone number can\'t be less than 8 or exceeded 11',
            contentType: ContentType.failure,
          );
        }
      }
    } else {
      _showSnackBar(
        title: 'Error',
        message: 'Failed to add Admin: Make sure you entered all fields',
        contentType: ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Admin",
          style: TextStyle(color: kTextColor),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: !imagesLoaded
          ? Center(child: CircularProgressIndicator())
          : ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            prefixIcon: (isFocused) => Icon(Icons.person,
                                color:
                                    isFocused ? kPrimaryColor : Colors.black),
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: lastNameController,
                            label: "Last Name",
                            hintText: "Enter Last Name",
                            prefixIcon: (isFocused) => Icon(Icons.person,
                                color:
                                    isFocused ? kPrimaryColor : Colors.black),
                          ),
                        ),
                        CustomDropdownButton(
                          addDropdownButton: AddDropdownButton(
                            label: "Marital Status",
                            hint: "Select Marital Status",
                            items: ["SINGLE", "MARRIED", "DIVORCED", "WIDOWED"],
                            value: valueChooseMaritalStatus,
                            onChanged: (data) =>
                                setState(() => valueChooseMaritalStatus = data),
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
                            onChanged: (data) =>
                                setState(() => valueChooseGender = data),
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
                            prefixIcon: (isFocused) => Icon(Icons.email,
                                color:
                                    isFocused ? kPrimaryColor : Colors.black),
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: phoneController,
                            label: "Phone",
                            hintText: "Enter Phone",
                            keyboardType: TextInputType.number,
                            prefixIcon: (isFocused) => Icon(Icons.phone_android,
                                color:
                                    isFocused ? kPrimaryColor : Colors.black),
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
