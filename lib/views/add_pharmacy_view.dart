// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/services/add_new_pharmacy_service.dart';
// import 'package:testtt/widgets/button_widget.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'package:testtt/widgets/custom_add_textfield_widget.dart';

// class AddPharmacyView extends StatefulWidget {
//   const AddPharmacyView({super.key});

//   @override
//   State<AddPharmacyView> createState() => _AddPharmacyViewState();
// }

// class _AddPharmacyViewState extends State<AddPharmacyView> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController googleMapsLinkController =
//       TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController ownerNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   bool isLoading = false;
//   bool imagesLoaded = false;

//   void clearFields() {
//     setState(() {
//       nameController.clear();
//       googleMapsLinkController.clear();
//       locationController.clear();
//       ownerNameController.clear();
//       emailController.clear();
//       phoneController.clear();
//     });
//   }

//   Future<void> handleSubmit() async {
//     if (_formKey.currentState!.validate()) return;
//     setState(() => isLoading = true);

//     try {
//       final addPharmacyService = AddNewPharmacyService();
//       final success = await addPharmacyService.addNewPharmacy(
//         name: nameController.text,
//         googleMapsLink: googleMapsLinkController.text,
//         address: locationController.text,
//         ownerName: ownerNameController.text,
//         email: emailController.text,
//         role: "PHARMACY",
//         userPhoneNumbers: [phoneController.text],
//         enabled: true,
//       );
//       if (success) {
//         clearFields();
//         _showSnackBar(
//           title: 'Success',
//           message: 'Lab added successfully',
//           contentType: ContentType.success,
//         );
//       }
//     } catch (error) {
//       _handleError(error);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   void _showSnackBar({
//     required String title,
//     required String message,
//     required ContentType contentType,
//   }) {
//     final snackBar = SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//         title: title,
//         message: message,
//         contentType: contentType,
//       ),
//     );

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }

//   void _handleError(Object error) {
//     print("Failed to add Lab: $error");

//     if (error is Exception) {
//       final errorMessage = error.toString();

//       if (errorMessage.contains("409")) {
//         if (errorMessage.contains("This phone number  already exists")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Phone number already exists',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage.contains("The user email ") &&
//             errorMessage.contains(" already exists")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'User email already exists',
//             contentType: ContentType.failure,
//           );
//         }
//       } else if (errorMessage.contains("400")) {
//         if (errorMessage
//             .contains("Lab name must be between 2 and 100 characters")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Lab name must be between 2 and 100 characters',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage.contains("Invalid Google Maps link")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Invalid Google Maps link',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage
//             .contains("Address must be between 10 and 255 characters")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Location must be between 10 and 255 characters',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage
//             .contains("Owner name must be between 2 and 100 characters")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Owner name must be between 2 and 100 characters',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage
//             .contains("Specialization must be between 3 and 100 characters")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Specialization must be between 3 and 100 characters',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage.contains("Invalid email format")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Invalid email format',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage.contains("Invalid phone number format")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Invalid phone number format',
//             contentType: ContentType.failure,
//           );
//         } else if (errorMessage.contains("is required")) {
//           _showSnackBar(
//             title: 'Error',
//             message: 'Make sure you entered all fields',
//             contentType: ContentType.failure,
//           );
//         }
//       }
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadImages(context);
//   }

//   Future<void> _loadImages(BuildContext context) async {
//     await Future.wait([
//       precacheImage(AssetImage("lib/icons/pharmacy.png"), context),
//     ]);
//     setState(() {
//       imagesLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Add Pharmacy",
//           style: TextStyle(color: kTextColor),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: !imagesLoaded
//           ? Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : ModalProgressHUD(
//               inAsyncCall: isLoading,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16),
//                 child: Form(
//                   key: _formKey,
//                   child: SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 8,
//                         ),
//                         CustomAddTextField(
//                           addTextField: AddTextField(
//                             controller: nameController,
//                             label: "Pharmacy Name",
//                             hintText: "Enter Pharmacy Name",
//                             prefixIcon: (bool isFocused) {
//                               return Image.asset(
//                                 "lib/icons/pharmacy.png",
//                                 height: 25,
//                                 color: isFocused ? kPrimaryColor : Colors.black,
//                               );
//                             },
//                           ),
//                         ),
//                         CustomAddTextField(
//                           addTextField: AddTextField(
//                             controller: googleMapsLinkController,
//                             label: "Google Maps Link",
//                             hintText: "Enter Google Maps Link",
//                             prefixIcon: (bool isFocused) {
//                               return Icon(
//                                 Icons.link,
//                                 color: isFocused ? kPrimaryColor : Colors.black,
//                               );
//                             },
//                           ),
//                         ),
//                         CustomAddTextField(
//                           addTextField: AddTextField(
//                             controller: locationController,
//                             label: "Location",
//                             hintText: "Enter Location",
//                             prefixIcon: (bool isFocused) {
//                               return Icon(
//                                 Icons.location_on,
//                                 color: isFocused ? kPrimaryColor : Colors.black,
//                               );
//                             },
//                           ),
//                         ),
//                         CustomAddTextField(
//                           addTextField: AddTextField(
//                             controller: ownerNameController,
//                             label: "Owner Name",
//                             hintText: "Enter Owner Name",
//                             prefixIcon: (bool isFocused) {
//                               return Icon(
//                                 Icons.person,
//                                 color: isFocused ? kPrimaryColor : Colors.black,
//                               );
//                             },
//                           ),
//                         ),
//                         CustomAddTextField(
//                           addTextField: AddTextField(
//                             controller: emailController,
//                             label: "Pharmacy Email",
//                             hintText: "Enter Email",
//                             prefixIcon: (bool isFocused) {
//                               return Icon(
//                                 Icons.email,
//                                 color: isFocused ? kPrimaryColor : Colors.black,
//                               );
//                             },
//                           ),
//                         ),
//                         CustomAddTextField(
//                           addTextField: AddTextField(
//                             controller: phoneController,
//                             label: "Pharmacy Phone",
//                             hintText: "Enter Phone",
//                             keyboardType: TextInputType.number,
//                             prefixIcon: (bool isFocused) {
//                               return Icon(
//                                 Icons.phone_android,
//                                 color: isFocused ? kPrimaryColor : Colors.black,
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Button(
//                               text: "Submit",
//                               onPressed: handleSubmit,
//                             ),
//                             SizedBox(width: 35),
//                             Button(
//                               text: "Clear",
//                               onPressed: clearFields,
//                               color: Colors.red,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_pharmacy_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_add_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPharmacyView extends StatefulWidget {
  const AddPharmacyView({super.key});

  @override
  State<AddPharmacyView> createState() => _AddPharmacyViewState();
}

class _AddPharmacyViewState extends State<AddPharmacyView> {
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
      final addPharmacyService = AddNewPharmacyService();
      final success = await addPharmacyService.addNewPharmacy(
        name: nameController.text,
        googleMapsLink: googleMapsLinkController.text,
        address: locationController.text,
        ownerName: ownerNameController.text,
        email: emailController.text,
        role: "PHARMACY",
        userPhoneNumbers: [phoneController.text],
        enabled: true,
      );
      if (success) {
        clearFields();
        _showSnackBar(
          title: 'Success',
          message: 'Pharmacy added successfully',
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
    print("Failed to add Pharmacy: $error");

    if (error is Exception) {
      final errorMessage = error.toString();

      if (errorMessage.contains("409")) {
        if (errorMessage.contains("This phone number  already exists")) {
          _showSnackBar(
            title: 'Error',
            message: 'Phone number already exists',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("User email ") &&
            errorMessage.contains(" already exists")) {
          _showSnackBar(
            title: 'Error',
            message: 'User email already exists',
            contentType: ContentType.failure,
          );
        }
      } else if (errorMessage.contains("400")) {
        if (errorMessage.contains("Name must be between 3 and 50 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Pharmacy Name must be between 3 and 50 characters',
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
      precacheImage(const AssetImage("lib/icons/pharmacy.png"), context),
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
        title: const Text(
          "Add Pharmacy",
          style: TextStyle(color: kTextColor),
        ),
        iconTheme: const IconThemeData(color: kTextColor),
      ),
      body: !imagesLoaded
          ? const Center(child: CircularProgressIndicator())
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
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: nameController,
                            label: "Pharmacy Name",
                            hintText: "Enter Pharmacy Name",
                            prefixIcon: (bool isFocused) {
                              return Image.asset(
                                "lib/icons/pharmacy.png",
                                height: 25,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: googleMapsLinkController,
                            label: "Google Maps Link",
                            hintText: "Enter Google Maps Link",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.link,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: locationController,
                            label: "Location",
                            hintText: "Enter Location",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.location_on,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: ownerNameController,
                            label: "Owner Name",
                            hintText: "Enter Owner Name",
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
                            controller: emailController,
                            label: "Pharmacy Email",
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
                            label: "Pharmacy Phone",
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
