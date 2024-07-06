import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_doctor_model.dart';
import 'package:medicory/services/edit_doctor_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_edit_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_edit_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

typedef void OnDoctorUpdated(bool enabled);

class doctorDetailsView extends StatefulWidget {
  final GetDoctorModel getDoctorModel;
  final Function(
          bool enabled, String firstName, String middleName, String lastName)
      OnDoctorUpdated;

  const doctorDetailsView({
    Key? key,
    required this.getDoctorModel,
    required this.OnDoctorUpdated,
  }) : super(key: key);

  @override
  _doctorDetailsViewState createState() => _doctorDetailsViewState();
}

class _doctorDetailsViewState extends State<doctorDetailsView> {
  bool isLoading = false;
  bool imagesLoaded = false;

  late GetDoctorModel getDoctorModel;

  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _specializationController;
  late TextEditingController _licienceNumberController;
  late TextEditingController _nationalIdController;
  late TextEditingController _userEmailController;
  late TextEditingController _codeController;
  late TextEditingController _roleController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userPhoneNumberController;

  String? valueChooseGender;
  String? valueChooseMaritalStatus;
  String? firstName,
      middleName,
      lastName,
      specialization,
      licienceNumber,
      nationalId,
      gender,
      maritalStatus,
      email,
      password,
      phone;
  bool? enabled;
  bool showErrorDialog = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> genderOptions = ["MALE", "FEMALE"];
  List<String> maritalStatusOptions = [
    "SINGLE",
    "MARRIED",
    "DIVORCED",
    "WIDOWED"
  ];

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
      precacheImage(AssetImage("lib/icons/setting.png"), context),
      precacheImage(AssetImage("lib/icons/button.png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    getDoctorModel = widget.getDoctorModel;

    _firstNameController =
        TextEditingController(text: getDoctorModel.firstName);
    _middleNameController =
        TextEditingController(text: getDoctorModel.middleName);
    _lastNameController = TextEditingController(text: getDoctorModel.lastName);
    _specializationController =
        TextEditingController(text: getDoctorModel.specialization);
    _licienceNumberController =
        TextEditingController(text: getDoctorModel.licenceNumber);
    _nationalIdController =
        TextEditingController(text: '${getDoctorModel.nationalId}');
    _userEmailController = TextEditingController(text: getDoctorModel.email);
    _codeController = TextEditingController(text: getDoctorModel.code);
    _roleController = TextEditingController(text: getDoctorModel.role);
    _userPasswordController = TextEditingController(text: "************");
    _userPhoneNumberController =
        TextEditingController(text: getDoctorModel.userPhoneNumbers[0]);

    // Initialize dropdown and checkbox values
    valueChooseGender = getDoctorModel.gender;
    valueChooseMaritalStatus = getDoctorModel.maritalStatus;
    enabled = getDoctorModel.enabled;
  }

  void resetFormFields() {
    setState(() {
      _firstNameController.text = getDoctorModel.firstName;
      _middleNameController.text = getDoctorModel.middleName;
      _lastNameController.text = getDoctorModel.lastName;
      _specializationController.text = getDoctorModel.specialization;
      _licienceNumberController.text = getDoctorModel.licenceNumber;
      _nationalIdController.text = getDoctorModel.nationalId;
      _userEmailController.text = getDoctorModel.email;
      _codeController.text = getDoctorModel.code;
      _roleController.text = getDoctorModel.role;
      _userPasswordController.text = "************";
      _userPhoneNumberController.text = getDoctorModel.userPhoneNumbers[0];

      valueChooseGender = getDoctorModel.gender;
      valueChooseMaritalStatus = getDoctorModel.maritalStatus;
      enabled = getDoctorModel.enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!imagesLoaded) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Doctor Details",
            style: TextStyle(
              color: kTextColor,
            ),
          ),
          iconTheme: IconThemeData(color: kTextColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "First Name",
                    controller: _firstNameController,
                    onchange: (data) {
                      firstName = data;
                    },
                    hintText: 'Enter First Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Middle Name",
                    controller: _middleNameController,
                    onchange: (data) {
                      middleName = data;
                    },
                    hintText: 'Enter Middle Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Last Name",
                    controller: _lastNameController,
                    onchange: (data) {
                      lastName = data;
                    },
                    hintText: 'Enter Last Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Specialization",
                    controller: _specializationController,
                    onchange: (data) {
                      specialization = data;
                    },
                    hintText: 'Enter Specialization',
                    prefixIcon: Image.asset(
                      "lib/icons/badge.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Licence Number",
                    controller: _licienceNumberController,
                    onchange: (data) {
                      licienceNumber = data;
                    },
                    hintText: 'Enter Licence Number',
                    prefixIcon: Image.asset(
                      "lib/icons/diploma (1).png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "National ID",
                    controller: _nationalIdController,
                    onchange: (data) {
                      nationalId = data;
                    },
                    hintText: 'Enter National ID',
                    prefixIcon: Image.asset(
                      "lib/icons/id-card1.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditDropDownButton(
                    label: "Marital Status",
                    hint: "Select Marital Status",
                    value: valueChooseMaritalStatus ??
                        widget.getDoctorModel.maritalStatus,
                    items: maritalStatusOptions,
                    onChanged: (data) {
                      setState(() {
                        valueChooseMaritalStatus = data;
                      });
                    },
                    prefixIcon: Image.asset(
                      "lib/icons/couple.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditDropDownButton(
                    label: "Gender",
                    hint: "Select Gender",
                    value: valueChooseGender ?? widget.getDoctorModel.gender,
                    items: genderOptions,
                    onChanged: (data) {
                      setState(() {
                        valueChooseGender = data;
                      });
                    },
                    prefixIcon: Image.asset(
                      "lib/icons/gender.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Code",
                    controller: _codeController,
                    onchange: (data) {},
                    hintText: 'Enter Code',
                    prefixIcon: Icon(
                      Icons.numbers,
                      color: kPrimaryColor,
                    ),
                    readOnly: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Email",
                    controller: _userEmailController,
                    onchange: (data) {
                      email = data;
                    },
                    hintText: 'Enter Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Password",
                    controller: _userPasswordController,
                    onchange: (data) {
                      password = data;
                    },
                    hintText: 'Enter Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Role",
                    readOnly: true,
                    controller: _roleController,
                    onchange: (data) {},
                    hintText: 'Enter role',
                    prefixIcon: Image.asset(
                      "lib/icons/setting.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Phone",
                    controller: _userPhoneNumberController,
                    onchange: (data) {
                      phone = data;
                    },
                    hintText: 'Enter Phone',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditDropDownButton(
                    label: "Enabled",
                    hint: "Select Enabled",
                    value: enabled != null ? enabled.toString() : '',
                    items: ['true', 'false'],
                    onChanged: (data) {
                      setState(() {
                        enabled = data == 'true';
                      });
                    },
                    prefixIcon: Image.asset(
                      "lib/icons/button.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              submitData(context);
                            }
                            widget.OnDoctorUpdated(
                                enabled ?? false,
                                firstName ?? getDoctorModel.firstName,
                                middleName ?? getDoctorModel.middleName,
                                lastName ?? getDoctorModel.lastName);
                          },
                          text: "Update",
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Button(
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.topSlide,
                              dialogType: DialogType.question,
                              title: 'Warning',
                              desc: 'Are You Sure You Want To Cancel Changes?',
                              btnOkOnPress: () {
                                setState(() {
                                  resetFormFields();
                                });
                              },
                              btnCancelOnPress: () {},
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                            ).show();
                          },
                          color: Colors.red,
                          text: "Cancel",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitData(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final editDoctorService = EditDoctorService();
      final sucess = await editDoctorService.EditDoctor(
        id: widget.getDoctorModel.id,
        firstName: firstName ?? getDoctorModel.firstName,
        middleName: middleName ?? getDoctorModel.middleName,
        lastName: lastName ?? getDoctorModel.lastName,
        licenceNumber: licienceNumber ?? getDoctorModel.licenceNumber,
        specialization: specialization ?? getDoctorModel.specialization,
        nationalId: nationalId ?? getDoctorModel.nationalId.toString(),
        maritalStatus: valueChooseMaritalStatus ?? getDoctorModel.maritalStatus,
        gender: valueChooseGender ?? getDoctorModel.gender,
        code: getDoctorModel.code,
        email: email ?? getDoctorModel.email,
        password: password != "************" ? password : null,
        role: "DOCTOR",
        userPhoneNumbers: [phone ?? getDoctorModel.userPhoneNumbers[0]],
        enabled: enabled ?? getDoctorModel.enabled,
      );
      if (sucess) {
        _showSnackBar(
          title: 'Success',
          message: 'Doctor updated successfully',
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
    print("Failed to update Doctor: $error");

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
        } else if (errorMessage.contains("userPhoneNumbers[0]") &&
            errorMessage.contains("Invalid phone number format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid phone number format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("userPhoneNumbers[0]") &&
            errorMessage
                .contains("phone number can't be less than 8 or exceeded 11")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid phone number format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("password") &&
            errorMessage.contains(
                "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character")) {
          _showSnackBar(
            title: 'Error',
            message:
                'Password must contain one uppercase letter, lowercase letter, number and special character',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("password") &&
            errorMessage
                .contains("Password must be at least 12 characters long")) {
          _showSnackBar(
            title: 'Error',
            message: 'Password must be at least 12 characters long',
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
    setState(() => isLoading = false);
  }
}
