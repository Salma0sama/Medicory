import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_admin_model.dart';
import 'package:medicory/services/edit_admin_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_edit_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_edit_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

typedef void OnAdminUpdated(bool enabled);

class AdminDetailsView extends StatefulWidget {
  final GetAdminModel getAdminModel;
  final Function(bool enabled, String firstName, String lastName)
      onAdminUpdated;

  const AdminDetailsView({
    Key? key,
    required this.getAdminModel,
    required this.onAdminUpdated,
  }) : super(key: key);

  @override
  _AdminDetailsViewState createState() => _AdminDetailsViewState();
}

class _AdminDetailsViewState extends State<AdminDetailsView> {
  bool isLoading = false;
  bool imagesLoaded = false;

  late GetAdminModel getAdminModel;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userEmailController;
  late TextEditingController _codeController;
  late TextEditingController _roleController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userPhoneNumberController;

  String? valueChooseGender;
  String? valueChooseMaritalStatus;
  String? firstName,
      lastName,
      fullName,
      gender,
      maritalStatus,
      code,
      email,
      password,
      role,
      phone;
  bool? enabled;

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
      precacheImage(AssetImage("lib/icons/couple.png"), context),
      precacheImage(AssetImage("lib/icons/gender.png"), context),
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

    getAdminModel = widget.getAdminModel;

    _firstNameController = TextEditingController(text: getAdminModel.firstName);
    _lastNameController = TextEditingController(text: getAdminModel.lastName);
    _userEmailController = TextEditingController(text: getAdminModel.email);
    _codeController = TextEditingController(text: getAdminModel.code);
    _roleController = TextEditingController(text: getAdminModel.role);
    _userPasswordController = TextEditingController(text: "************");
    _userPhoneNumberController =
        TextEditingController(text: getAdminModel.userPhoneNumbers[0]);

    // Initialize dropdown and checkbox values
    valueChooseGender = getAdminModel.gender;
    valueChooseMaritalStatus = getAdminModel.maritalStatus;
    enabled = getAdminModel.enabled;
  }

  void resetFormFields() {
    setState(() {
      _firstNameController.text = getAdminModel.firstName;
      _lastNameController.text = getAdminModel.lastName;
      _userEmailController.text = getAdminModel.email;
      _codeController.text = getAdminModel.code;
      _roleController.text = getAdminModel.role;
      _userPasswordController.text = "************";
      _userPhoneNumberController.text = getAdminModel.userPhoneNumbers[0];

      valueChooseGender = getAdminModel.gender;
      valueChooseMaritalStatus = getAdminModel.maritalStatus;
      enabled = getAdminModel.enabled;
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
            "Admin Details",
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
                  child: CustomEditDropDownButton(
                    label: "Marital Status",
                    hint: "Select Marital Status",
                    value: valueChooseMaritalStatus ??
                        widget.getAdminModel.maritalStatus,
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
                    value: valueChooseGender ?? widget.getAdminModel.gender,
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
                    onchange: (data) {
                      code = data;
                    },
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
                    onchange: (data) {
                      role = data;
                    },
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
                            widget.onAdminUpdated(
                                enabled ?? false,
                                firstName ?? getAdminModel.firstName,
                                lastName ?? getAdminModel.lastName);
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
    setState(() => isLoading = true);
    try {
      final editAdminService = EditAdminService();
      final sucess = await editAdminService.EditAdmin(
        id: widget.getAdminModel.id,
        firstName: firstName ?? getAdminModel.firstName,
        lastName: lastName ?? getAdminModel.lastName,
        maritalStatus: valueChooseMaritalStatus ?? getAdminModel.maritalStatus,
        gender: valueChooseGender ?? getAdminModel.gender,
        code: getAdminModel.code,
        email: email ?? getAdminModel.email,
        password: password != "************" ? password : null,
        role: "ADMIN",
        userPhoneNumbers: [phone ?? getAdminModel.userPhoneNumbers[0]],
        enabled: enabled ?? getAdminModel.enabled,
      );
      if (sucess) {
        print("Admin updated successfully");
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Admin updated successfully',
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
          message: 'Failed to updated Admin: Make sure you entered all fields',
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
        } else if (errorMessage.contains("400") &&
            errorMessage.contains("firstName") &&
            errorMessage
                .contains("First name can not be less than 3 or exceed 15")) {
          // Handle the case where email already exists
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message:
                  'First name can not be less than 3 or exceed 15 characters',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (errorMessage.contains("400") &&
            errorMessage.contains("lastName") &&
            errorMessage
                .contains("Last name can not be less than 3 or exceed 15")) {
          // Handle the case where email already exists
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message:
                  'Last name can not be less than 3 or exceed 15 characters',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (errorMessage.contains("400") &&
            errorMessage.contains("email") &&
            errorMessage.contains("Invalid email")) {
          // Handle the case where email already exists
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: 'Invalid email format',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (errorMessage.contains("400") &&
            errorMessage.contains("userPhoneNumbers[0]") &&
            errorMessage.contains("Invalid phone number format")) {
          // Handle the case where email already exists
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: 'Invalid phone number format',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (errorMessage.contains("400") &&
            errorMessage.contains("password") &&
            errorMessage
                .contains("Password must be at least 12 characters long")) {
          // Handle the case where email already exists
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: 'Password must be at least 12 characters long',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (errorMessage.contains("400") &&
            errorMessage.contains("password") &&
            errorMessage.contains(
                "Password must contain at least one digit, one uppercase letter, one lowercase letter, and one special character")) {
          // Handle the case where email already exists
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message:
                  'Password must contain digits, uppercase letters, lowercase letters and special characters',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    }
    setState(() => isLoading = false);
  }
}
