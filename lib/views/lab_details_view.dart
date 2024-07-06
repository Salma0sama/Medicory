import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_lab_model.dart';
import 'package:medicory/services/edit_lab_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_edit_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_edit_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

typedef void OnLabUpdated(bool enabled);

class LabDetailsView extends StatefulWidget {
  final GetLabModel getLabModel;
  final Function(bool enabled, String labName) OnLabUpdated;

  const LabDetailsView({
    Key? key,
    required this.getLabModel,
    required this.OnLabUpdated,
  }) : super(key: key);

  @override
  _LabDetailsViewState createState() => _LabDetailsViewState();
}

class _LabDetailsViewState extends State<LabDetailsView> {
  bool isLoading = false;
  bool imagesLoaded = false;

  late GetLabModel getLabModel;

  late TextEditingController _pharmacyNameController;
  late TextEditingController _googleMabLinkController;
  late TextEditingController _locationController;
  late TextEditingController _ownerNameController;
  late TextEditingController _userEmailController;
  late TextEditingController _codeController;
  late TextEditingController _roleController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userPhoneNumberController;

  String? labName,
      googleMapLink,
      ownerName,
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
      precacheImage(const AssetImage("lib/icons/pharmacy.png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    getLabModel = widget.getLabModel;

    _pharmacyNameController = TextEditingController(text: getLabModel.name);
    _ownerNameController = TextEditingController(text: getLabModel.ownerName);
    _locationController = TextEditingController(text: getLabModel.address);
    _googleMabLinkController =
        TextEditingController(text: getLabModel.googleMapsLink);
    _userEmailController = TextEditingController(text: getLabModel.email);
    _codeController = TextEditingController(text: getLabModel.code);
    _roleController = TextEditingController(text: getLabModel.role);
    _userPasswordController = TextEditingController(text: "************");
    _userPhoneNumberController =
        TextEditingController(text: getLabModel.userPhoneNumbers[0]);
    enabled = getLabModel.enabled;
  }

  void resetFormFields() {
    setState(() {
      _pharmacyNameController.text = getLabModel.name;
      _ownerNameController.text = getLabModel.ownerName;
      _locationController.text = getLabModel.address;
      _googleMabLinkController.text = getLabModel.googleMapsLink;
      _userEmailController.text = getLabModel.email;
      _codeController.text = getLabModel.code;
      _roleController.text = getLabModel.role;
      _userPasswordController.text = "************";
      _userPhoneNumberController.text = getLabModel.userPhoneNumbers[0];
      enabled = getLabModel.enabled;
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
            "Lab Details",
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
                    label: "Lab Name",
                    controller: _pharmacyNameController,
                    onchange: (data) {
                      labName = data;
                    },
                    hintText: 'Enter pharmacy Name',
                    prefixIcon: Image.asset(
                      "lib/icons/pharmacy.png",
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
                    label: "Owner Name",
                    controller: _ownerNameController,
                    onchange: (data) {
                      ownerName = data;
                    },
                    hintText: 'Enter Owner Name',
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
                    label: "Lab Email",
                    controller: _userEmailController,
                    onchange: (data) {
                      email = data;
                    },
                    hintText: 'Enter pharmacy Email',
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
                            widget.OnLabUpdated(
                                enabled ?? false, labName ?? getLabModel.name);
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
      final editAdminService = EditLabService();
      final sucess = await editAdminService.EditLab(
          id: getLabModel.id,
          name: labName ?? getLabModel.name,
          googleMapsLink: googleMapLink ?? getLabModel.googleMapsLink,
          address: location ?? getLabModel.address,
          ownerName: ownerName ?? getLabModel.ownerName,
          code: getLabModel.code,
          email: email ?? getLabModel.email,
          password: password != "************" ? password : null,
          role: "LAB",
          userPhoneNumbers: [phone ?? getLabModel.userPhoneNumbers[0]],
          enabled: enabled ?? getLabModel.enabled);
      if (sucess) {
        _showSnackBar(
          title: 'Success',
          message: 'Lab updated successfully',
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
    print("Failed to Update Lab: $error");

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
}
