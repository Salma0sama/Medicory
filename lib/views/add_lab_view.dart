import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_lab_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_add_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddLabView extends StatefulWidget {
  const AddLabView({Key? key}) : super(key: key);

  @override
  _AddLabViewState createState() => _AddLabViewState();
}

class _AddLabViewState extends State<AddLabView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController googleMapsLinkController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool imagesLoaded = false;

  void clearFields() {
    setState(() {
      nameController.clear();
      googleMapsLinkController.clear();
      locationController.clear();
      ownerNameController.clear();
      emailController.clear();
      phoneController.clear();
    });
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final addNewLabService = AddNewLabService();
      final success = await addNewLabService.addNewLab(
        name: nameController.text,
        googleMapsLink: googleMapsLinkController.text,
        address: locationController.text,
        ownerName: ownerNameController.text,
        email: emailController.text,
        role: "LAB",
        userPhoneNumbers: [phoneController.text],
        enabled: true,
      );
      if (success) {
        clearFields();
        _showSnackBar(
          title: 'Success',
          message: 'Lab added successfully',
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
    print("Failed to add Lab: $error");

    if (error is Exception) {
      final errorMessage = error.toString();

      if (errorMessage.contains("409")) {
        if (errorMessage.contains("This phone number  already exists")) {
          _showSnackBar(
            title: 'Error',
            message: 'Phone number already exists',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("The user email ") &&
            errorMessage.contains(" already exists")) {
          _showSnackBar(
            title: 'Error',
            message: 'User email already exists',
            contentType: ContentType.failure,
          );
        }
      } else if (errorMessage.contains("400")) {
        if (errorMessage
            .contains("Lab name must be between 2 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Lab name must be between 2 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("Invalid Google Maps link")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid Google Maps link',
            contentType: ContentType.failure,
          );
        } else if (errorMessage
            .contains("Address must be between 10 and 255 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Location must be between 10 and 255 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage
            .contains("Owner name must be between 2 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Owner name must be between 2 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage
            .contains("Specialization must be between 3 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Specialization must be between 3 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("Invalid email format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid email format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("Invalid phone number format")) {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages(context);
  }

  Future<void> _loadImages(BuildContext context) async {
    await Future.wait([
      precacheImage(AssetImage("lib/icons/laboratory (1).png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
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
          "Add Lab",
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
                        SizedBox(
                          height: 8,
                        ),
                        _buildTextField(
                          controller: nameController,
                          label: "Lab Name",
                          hintText: "Enter Lab Name",
                          prefixIcon: (isFocused) => Image.asset(
                            "lib/icons/laboratory (1).png",
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
                          controller: emailController,
                          label: "Lab Email",
                          hintText: "Enter Email",
                          prefixIcon: (isFocused) => Icon(
                            Icons.email,
                            color: isFocused ? kPrimaryColor : Colors.black,
                          ),
                        ),
                        _buildTextField(
                          controller: phoneController,
                          label: "Lab Phone",
                          hintText: "Enter Phone",
                          keyboardType: TextInputType.number,
                          prefixIcon: (isFocused) => Icon(
                            Icons.phone_android,
                            color: isFocused ? kPrimaryColor : Colors.black,
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
