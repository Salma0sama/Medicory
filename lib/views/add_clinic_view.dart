import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_clinic_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_add_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddClinicView extends StatefulWidget {
  const AddClinicView({super.key});

  @override
  State<AddClinicView> createState() => _AddClinicViewState();
}

class _AddClinicViewState extends State<AddClinicView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController googleMapsLinkController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
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
      precacheImage(const AssetImage("lib/icons/badge.png"), context),
      precacheImage(const AssetImage("lib/icons/clinic.png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  void clearFields() {
    nameController.clear();
    googleMapsLinkController.clear();
    locationController.clear();
    ownerNameController.clear();
    specializationController.clear();
    emailController.clear();
    phoneController.clear();
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final addClinicService = AddNewClinicService();
      final success = await addClinicService.addNewClinic(
        name: nameController.text,
        googleMapsLink: googleMapsLinkController.text,
        address: locationController.text,
        ownerName: ownerNameController.text,
        specialization: specializationController.text,
        email: emailController.text,
        role: "CLINIC",
        userPhoneNumbers: [phoneController.text],
        enabled: true,
      );
      if (success) {
        clearFields();
        _showSnackBar(
          title: 'Success',
          message: 'Clinic added successfully',
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
    print("Failed to add Clinic: $error");

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
        } else if (errorMessage.contains("The user email") &&
            errorMessage.contains("already exist")) {
          _showSnackBar(
            title: 'Error',
            message: 'User email already exists',
            contentType: ContentType.failure,
          );
        }
      } else if (errorMessage.contains("400")) {
        if (errorMessage.contains("name") &&
            errorMessage
                .contains("Clinic name must be between 3 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Clinic name must be between 3 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("googleMapsLink") &&
            errorMessage.contains("Invalid Google Maps link format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid Google Maps link format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("address") &&
            errorMessage
                .contains("Address must be between 10 and 255 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Location must be between 10 and 255 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("ownerName") &&
            errorMessage
                .contains("Owner name must be between 3 and 50 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Owner name must be between 3 and 50 characters',
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
        } else if (errorMessage.contains("is required")) {
          _showSnackBar(
            title: 'Error',
            message: 'Make sure you entered all fields',
            contentType: ContentType.failure,
          );
        }
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Widget Function(bool isFocused) prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CustomAddTextField(
      addTextField: AddTextField(
        controller: controller,
        label: label,
        hintText: hintText,
        keyboardType: keyboardType,
        prefixIcon: prefixIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Clinic",
          style: TextStyle(color: kTextColor),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: !imagesLoaded
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: nameController,
                          label: "Clinic Name",
                          hintText: "Enter Clinic Name",
                          prefixIcon: (isFocused) => Image.asset(
                            "lib/icons/clinic.png",
                            height: 25,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: googleMapsLinkController,
                          label: "Google Maps Link",
                          hintText: "Enter Google Maps Link",
                          prefixIcon: (isFocused) => Icon(
                            Icons.link,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: locationController,
                          label: "Location",
                          hintText: "Enter Location",
                          prefixIcon: (isFocused) => Icon(
                            Icons.location_on,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: ownerNameController,
                          label: "Owner Name",
                          hintText: "Enter Owner Name",
                          prefixIcon: (isFocused) => Icon(
                            Icons.person,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: specializationController,
                          label: "Specialization",
                          hintText: "Enter Specialization",
                          prefixIcon: (isFocused) => Image.asset(
                            "lib/icons/badge.png",
                            height: 25,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: emailController,
                          label: "Clinic Email",
                          hintText: "Enter Email",
                          prefixIcon: (isFocused) => Icon(
                            Icons.email,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: phoneController,
                          label: "Clinic Phone",
                          hintText: "Enter Phone",
                          keyboardType: TextInputType.number,
                          prefixIcon: (isFocused) => Icon(
                            Icons.phone_android,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              text: "Submit",
                              onPressed: handleSubmit,
                            ),
                            const SizedBox(width: 35),
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
