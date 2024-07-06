import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_owner_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_owner_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_add_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_add_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddOwnerView extends StatefulWidget {
  const AddOwnerView({super.key});

  @override
  State<AddOwnerView> createState() => _AddOwnerViewState();
}

class _AddOwnerViewState extends State<AddOwnerView> {
  String? valueChooseGender;
  String? valueChooseBloodType;
  String? valueChooseMaritalStatus;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController relativePhoneController = TextEditingController();
  final TextEditingController relativeRelationController =
      TextEditingController();
  final TextEditingController jopController = TextEditingController();

  bool isLoading = false;
  bool imagesLoaded = false;

  void clearFields() {
    firstNameController.clear();
    middleNameController.clear();
    lastNameController.clear();
    nationalIdController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    jopController.clear();
    relativePhoneController.clear();
    relativeRelationController.clear();
    setState(() {
      valueChooseMaritalStatus = null;
      valueChooseGender = null;
      valueChooseBloodType = null;
      selectedDay = null;
      selectedMonth = null;
      selectedYear = null;
    });
  }

  List<String> getDays() {
    return List<String>.generate(31, (index) => (index + 1).toString());
  }

  List<String> getMonths() {
    return List<String>.generate(12, (index) => (index + 1).toString());
  }

  List<String> getYears() {
    final currentYear = DateTime.now().year;
    return List<String>.generate(
        100, (index) => (currentYear - index).toString());
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate date fields
    if (selectedDay == null || selectedMonth == null || selectedYear == null) {
      // Show an error message or handle the validation failure.
      _showSnackBar(
        title: 'Error',
        message: 'Date of birth fields are incomplete.',
        contentType: ContentType.failure,
      );
      print("Date of birth fields are incomplete.");
      return;
    }

    // Pad with leading zeros if necessary
    String day = selectedDay!.padLeft(2, '0');
    String month = selectedMonth!.padLeft(2, '0');

    final dateOfBirth = '$selectedYear-$month-$day';

    setState(() => isLoading = true);
    try {
      final addOwnerService = AddNewOwnerService();
      final success = await addOwnerService.addNewOwner(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text,
        maritalStatus: valueChooseMaritalStatus!,
        nationalId: int.parse(nationalIdController.text), // Convert to int
        job: jopController.text,
        address: addressController.text,
        bloodType: valueChooseBloodType!,
        gender: valueChooseGender!,
        relativePhoneNumbers: [
          RelativePhoneNumber(
            phone: relativePhoneController.text,
            relation: relativeRelationController.text,
          ),
        ],
        user: UserDetail(
          email: emailController.text,
          role: "OWNER",
          userPhoneNumbers: [UserPhoneNumber(phone: phoneController.text)],
          enabled: true,
        ),
        dateOfBirth: dateOfBirth,
      );
      if (success) {
        clearFields();
        _showSnackBar(
          title: 'Success',
          message: 'Owner added successfully',
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
    print("$error");

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
        }
        if (errorMessage.contains("nationalId") &&
            errorMessage.contains("National ID must be exactly 14 digits")) {
          _showSnackBar(
            title: 'Error',
            message: 'National ID must be exactly 14 digits',
            contentType: ContentType.failure,
          );
        }
        if (errorMessage.contains("lastName") &&
            errorMessage
                .contains("Last name must be between 2 and 50 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Last name must be between 2 and 50 characters',
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
        } else if (errorMessage.contains("is required")) {
          _showSnackBar(
            title: 'Error',
            message: 'Make sure you entered all fields',
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
        }
      }
    } else if (error is FormatException) {
      final errorMessage = error.toString();
      if (errorMessage.contains("FormatException") &&
          errorMessage.contains("Invalid radix-10 number ")) {
        _showSnackBar(
          title: 'Error',
          message: 'Invalid Relative phone number format',
          contentType: ContentType.failure,
        );
      }
    } else {
      _showSnackBar(
        title: 'Error',
        message: 'Failed to add Owner: Make sure you entered all fields',
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
      precacheImage(AssetImage("lib/icons/gender.png"), context),
      precacheImage(AssetImage("lib/icons/couple.png"), context),
      precacheImage(AssetImage("lib/icons/id-card1.png"), context),
      precacheImage(AssetImage("lib/icons/public-relation.png"), context),
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
          "Add Owner",
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
                            label: "Middle Name",
                            hintText: "Enter Middle Name",
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
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdownButton(
                                addDropdownButton: AddDropdownButton(
                                  label: "Birth Date",
                                  hint: "Day",
                                  items: getDays(),
                                  value: selectedDay,
                                  onChanged: (data) {
                                    setState(() {
                                      selectedDay = data;
                                    });
                                  },
                                  prefixIcon: null,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomDropdownButton(
                                addDropdownButton: AddDropdownButton(
                                  label: "",
                                  hint: "Month",
                                  items: getMonths(),
                                  value: selectedMonth,
                                  onChanged: (data) {
                                    setState(() {
                                      selectedMonth = data;
                                    });
                                  },
                                  prefixIcon: null,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomDropdownButton(
                                addDropdownButton: AddDropdownButton(
                                  label: "",
                                  hint: "Year",
                                  items: getYears(),
                                  value: selectedYear,
                                  onChanged: (data) {
                                    setState(() {
                                      selectedYear = data;
                                    });
                                  },
                                  prefixIcon: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: addressController,
                            label: "Address",
                            hintText: "Enter Address",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.location_on,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomDropdownButton(
                          addDropdownButton: AddDropdownButton(
                            label: "Blood Type",
                            hint: "Select Blood Type",
                            items: [
                              "A_POSITIVE",
                              "A_NEGATIVE",
                              "B_POSITIVE",
                              "B_NEGATIVE",
                              "AB_POSITIVE",
                              "AB_NEGATIVE",
                              "O_POSITIVE",
                              "O_NEGATIVE"
                            ],
                            value: valueChooseBloodType,
                            onChanged: (data) {
                              setState(() {
                                valueChooseBloodType = data;
                              });
                            },
                            prefixIcon: (isFocused) => Icon(
                              Icons.bloodtype,
                              color: isFocused ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
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
                            keyboardType: TextInputType.number,
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
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: jopController,
                            label: "Job",
                            hintText: "Enter Job",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.work,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: relativePhoneController,
                            label: "Relative Phone",
                            hintText: "Enter Relative Phone",
                            prefixIcon: (bool isFocused) {
                              return Icon(
                                Icons.phone_android,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        CustomAddTextField(
                          addTextField: AddTextField(
                            controller: relativeRelationController,
                            label: "Relative Relation",
                            hintText: "Enter Relative Relation",
                            prefixIcon: (bool isFocused) {
                              return Image.asset(
                                "lib/icons/public-relation.png",
                                height: 25,
                                color: isFocused ? kPrimaryColor : Colors.black,
                              );
                            },
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
                            keyboardType: TextInputType.phone,
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
