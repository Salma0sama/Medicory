import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/services/edit_hospital_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_edit_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_edit_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

typedef void OnHospitalUpdated(bool enabled);

class HospitalDetailsView extends StatefulWidget {
  final GetHospitalModel getHospitalModel;
  final Function(bool enabled, String hospitalName) OnHospitalUpdated;

  const HospitalDetailsView({
    Key? key,
    required this.getHospitalModel,
    required this.OnHospitalUpdated,
  }) : super(key: key);

  @override
  _HospitalDetailsViewState createState() => _HospitalDetailsViewState();
}

class _HospitalDetailsViewState extends State<HospitalDetailsView> {
  bool isLoading = false;
  bool imagesLoaded = false;

  late GetHospitalModel getHospitalModel;

  late TextEditingController _hospitalNameController;
  late TextEditingController _googleMabLinkController;
  late TextEditingController _locationController;
  late TextEditingController _userEmailController;
  late TextEditingController _codeController;
  late TextEditingController _roleController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userPhoneNumberController;

  String? hospitalName,
      googleMapLink,
      location,
      email,
      password,
      locaton,
      phone;
  bool? enabled;
  bool showErrorDialog = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();

    getHospitalModel = widget.getHospitalModel;

    _hospitalNameController =
        TextEditingController(text: getHospitalModel.name);
    _locationController = TextEditingController(text: getHospitalModel.address);
    _googleMabLinkController =
        TextEditingController(text: getHospitalModel.googleMapsLink);
    _userEmailController = TextEditingController(text: getHospitalModel.email);
    _codeController = TextEditingController(text: getHospitalModel.code);
    _roleController = TextEditingController(text: getHospitalModel.role);
    _userPasswordController = TextEditingController(text: "************");
    _userPhoneNumberController =
        TextEditingController(text: getHospitalModel.userPhoneNumbers[0]);
    enabled = getHospitalModel.enabled;
  }

  void resetFormFields() {
    setState(() {
      _hospitalNameController.text = getHospitalModel.name;
      _locationController.text = getHospitalModel.address;
      _googleMabLinkController.text = getHospitalModel.googleMapsLink;
      _userEmailController.text = getHospitalModel.email;
      _codeController.text = getHospitalModel.code;
      _roleController.text = getHospitalModel.role;
      _userPasswordController.text = "************";
      _userPhoneNumberController.text = getHospitalModel.userPhoneNumbers[0];
      enabled = getHospitalModel.enabled;
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
            "Hospital Details",
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
                    label: "Hospital Name",
                    controller: _hospitalNameController,
                    onchange: (data) {
                      hospitalName = data;
                    },
                    hintText: 'Enter Hospital Name',
                    prefixIcon: Image.asset(
                      "lib/icons/hospital.png",
                      height: 25,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Google Maps Link",
                    controller: _googleMabLinkController,
                    onchange: (data) {
                      googleMapLink = data;
                    },
                    hintText: 'Enter Google Maps Link',
                    prefixIcon: Icon(
                      Icons.link,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Location",
                    controller: _locationController,
                    onchange: (data) {
                      locaton = data;
                    },
                    hintText: 'Enter Location',
                    prefixIcon: Icon(
                      Icons.person,
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
                            widget.OnHospitalUpdated(enabled ?? false,
                                hospitalName ?? getHospitalModel.name);
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
      final editHospitalService = EditHospitalService();
      final success = await editHospitalService.EditHospital(
          id: getHospitalModel.id,
          name: hospitalName ?? getHospitalModel.name,
          googleMapsLink: googleMapLink ?? getHospitalModel.googleMapsLink,
          address: location ?? getHospitalModel.address,
          code: getHospitalModel.code,
          email: email ?? getHospitalModel.email,
          password: password != "************" ? password : null,
          role: "HOSPITAL",
          userPhoneNumbers: [phone ?? getHospitalModel.userPhoneNumbers[0]],
          enabled: enabled ?? getHospitalModel.enabled);
      if (success) {
        _showSnackBar(
          title: 'Success',
          message: 'Hospital updated successfully',
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
    print("Failed to Update Hospital: $error");

    if (error is Exception) {
      final errorMessage = error.toString();

      if (errorMessage.contains("409")) {
        if (errorMessage.contains("This phone number  already exist")) {
          _showSnackBar(
            title: 'Error',
            message: 'Phone number already exists',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("user email ") &&
            errorMessage.contains(" already exist :)")) {
          _showSnackBar(
            title: 'Error',
            message: 'User email already exists',
            contentType: ContentType.failure,
          );
        }
      } else if (errorMessage.contains("400")) {
        if (errorMessage.contains("name") &&
            errorMessage.contains(
                "Hospital name must be between 2 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Hospital name must be between 2 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("googleMapsLink") &&
            errorMessage.contains("Invalid Google Maps link")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid Google Maps link',
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
        } else if (errorMessage.contains("email") &&
            errorMessage.contains("Invalid email format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid email format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("password") &&
            errorMessage.contains(
                "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character")) {
          _showSnackBar(
            title: 'Error',
            message:
                'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
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
        message: 'Failed to add Hospital: Make sure you entered all fields',
        contentType: ContentType.failure,
      );
    }
  }
}
