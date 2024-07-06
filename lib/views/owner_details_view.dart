import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/services/edit_owner_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_edit_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_edit_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

typedef void OnOwnerUpdated(bool enabled);

class ownerDetailsView extends StatefulWidget {
  final GetOwnerModel getOwnerModel;
  final List<RelativePhoneNumber> relativePhoneNumber;
  final UserDetail userDetail;
  final Function(
          bool enabled, String firstName, String middleName, String lastName)
      OnOwnerUpdated;

  const ownerDetailsView({
    Key? key,
    required this.getOwnerModel,
    required this.relativePhoneNumber,
    required this.userDetail,
    required this.OnOwnerUpdated,
  }) : super(key: key);

  @override
  _ownerDetailsViewState createState() => _ownerDetailsViewState();
}

class _ownerDetailsViewState extends State<ownerDetailsView> {
  bool isLoading = false;
  bool imagesLoaded = false;

  late GetOwnerModel getOwnerModel;
  late List<RelativePhoneNumber> relativePhoneNumbers;
  late UserDetail userDetail;

  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _nationalIdController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _jobController;
  late TextEditingController _relativePhoneController;
  late TextEditingController _relativeRelationController;
  late TextEditingController _userEmailController;
  late TextEditingController _codeController;
  late TextEditingController _roleController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userPhoneNumberController;

  String? valueChooseGender;
  String? valueChooseBloodType;
  String? valueChooseMaritalStatus;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? firstName,
      middleName,
      lastName,
      gender,
      dateOfBirth,
      address,
      bloodType,
      maritalStatus,
      job,
      email,
      password,
      userPhone,
      relativePhone,
      relativeRelation;
  bool? enabled;
  int? nationalId;
  bool showErrorDialog = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> genderOptions = ["MALE", "FEMALE"];
  List<String> bloodTypeOptions = [
    "A_POSITIVE",
    "A_NEGATIVE",
    "B_POSITIVE",
    "B_NEGATIVE",
    "AB_POSITIVE",
    "AB_NEGATIVE",
    "O_POSITIVE",
    "O_NEGATIVE"
  ];
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
    getOwnerModel = widget.getOwnerModel;
    relativePhoneNumbers = widget.relativePhoneNumber;
    userDetail = widget.userDetail;

    _firstNameController = TextEditingController(text: getOwnerModel.firstName);
    _middleNameController =
        TextEditingController(text: getOwnerModel.middleName);
    _lastNameController = TextEditingController(text: getOwnerModel.lastName);
    _dateOfBirthController =
        TextEditingController(text: getOwnerModel.dateOfBirth);
    _addressController = TextEditingController(text: getOwnerModel.address);
    _nationalIdController =
        TextEditingController(text: '${getOwnerModel.nationalId}');
    _jobController = TextEditingController(text: getOwnerModel.job);
    _relativePhoneController = TextEditingController(
        text: relativePhoneNumbers.isNotEmpty
            ? relativePhoneNumbers[0].phone
            : '');
    _relativeRelationController = TextEditingController(
        text: relativePhoneNumbers.isNotEmpty
            ? relativePhoneNumbers[0].relation
            : '');
    _codeController = TextEditingController(text: userDetail.code);
    _userEmailController = TextEditingController(text: userDetail.email);
    _userPasswordController = TextEditingController(text: '************');
    _roleController = TextEditingController(text: userDetail.role);
    _userPhoneNumberController = TextEditingController(
        text: userDetail.userPhoneNumbers.isNotEmpty
            ? userDetail.userPhoneNumbers[0].phone
            : '');
    enabled = userDetail.enabled;
  }

  void resetFormFields() {
    setState(() {
      _firstNameController.text = getOwnerModel.firstName;
      _middleNameController.text = getOwnerModel.middleName;
      _lastNameController.text = getOwnerModel.lastName;
      _nationalIdController.text = getOwnerModel.nationalId.toString();
      _userEmailController.text = userDetail.email;
      _codeController.text = userDetail.code;
      _roleController.text = userDetail.role;
      _userPasswordController.text = "************";
      _userPhoneNumberController.text = userDetail.userPhoneNumbers[0].phone;
      _dateOfBirthController.text = getOwnerModel.dateOfBirth;

      valueChooseGender = getOwnerModel.gender;
      valueChooseMaritalStatus = getOwnerModel.maritalStatus;
      enabled = userDetail.enabled;
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
            "Owner Details",
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
                  child: CustomEditDropDownButton(
                    label: "Gender",
                    hint: "Select Gender",
                    value: valueChooseGender ?? widget.getOwnerModel.gender,
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
                    label: "Date of Birth",
                    controller: _dateOfBirthController,
                    onchange: (data) {
                      dateOfBirth = data;
                    },
                    hintText: 'Enter Date Of Birth',
                    prefixIcon: Icon(
                      Icons.date_range_outlined,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Address",
                    controller: _addressController,
                    onchange: (data) {
                      address = data;
                    },
                    hintText: 'Enter Address',
                    prefixIcon: Icon(
                      Icons.location_on,
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
                    label: "Blood Type",
                    hint: "Select Blood Type",
                    value:
                        valueChooseBloodType ?? widget.getOwnerModel.bloodType,
                    items: bloodTypeOptions,
                    onChanged: (data) {
                      setState(() {
                        valueChooseBloodType = data;
                      });
                    },
                    prefixIcon: Icon(
                      Icons.bloodtype,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditDropDownButton(
                    label: "Marital Status",
                    hint: "Select Marital Status",
                    value: valueChooseMaritalStatus ??
                        widget.getOwnerModel.maritalStatus,
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
                  child: CustomEditTextField(
                    label: "Job",
                    controller: _jobController,
                    onchange: (data) {
                      job = data;
                    },
                    hintText: 'Enter Job',
                    prefixIcon: Icon(
                      Icons.work,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Relative Phone",
                    controller: _relativePhoneController,
                    onchange: (data) {
                      relativePhone = data;
                    },
                    hintText: 'Enter Relative Phone',
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomEditTextField(
                    label: "Relative Relation",
                    controller: _relativeRelationController,
                    onchange: (data) {
                      relativeRelation = data;
                    },
                    hintText: 'Enter Relative Relation',
                    prefixIcon: Icon(
                      Icons.numbers,
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
                      userPhone = data;
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
                            widget.OnOwnerUpdated(
                                enabled ?? false,
                                firstName ?? getOwnerModel.firstName,
                                middleName ?? getOwnerModel.middleName,
                                lastName ?? getOwnerModel.lastName);
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
      final editOwnerService = EditOwnerService();
      final sucess = await editOwnerService.EditOwner(
        id: getOwnerModel.id,
        firstName: firstName ?? getOwnerModel.firstName,
        middleName: middleName ?? getOwnerModel.middleName,
        lastName: lastName ?? getOwnerModel.lastName,
        gender: valueChooseGender ?? getOwnerModel.gender,
        dateOfBirth: dateOfBirth ?? getOwnerModel.dateOfBirth,
        address: address ?? getOwnerModel.address,
        bloodType: valueChooseBloodType ?? getOwnerModel.bloodType,
        nationalId: getOwnerModel.nationalId,
        maritalStatus: valueChooseMaritalStatus ?? getOwnerModel.maritalStatus,
        job: job ?? getOwnerModel.job,
        relativePhoneNumbers:
            widget.getOwnerModel.relativePhoneNumbers.map((relative) {
          return RelativePhoneNumber(
            id: relative.id,
            phone: relativePhone ?? relative.phone,
            relation: relativeRelation ?? relative.relation,
          );
        }).toList(),
        user: UserDetail(
          code: getOwnerModel.user.code,
          email: email ?? getOwnerModel.user.email,
          password: password != "************" ? password : null,
          role: "OWNER",
          userPhoneNumbers: getOwnerModel.user.userPhoneNumbers.map((phone) {
            return UserPhoneNumber(
              id: phone.id,
              phone: userPhone ?? phone.phone,
            );
          }).toList(),
          enabled: enabled ?? getOwnerModel.user.enabled,
        ),
      );
      if (sucess) {
        _showSnackBar(
          title: 'Success',
          message: 'Owner updated successfully',
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
    print("Failed to update Owner: $error");

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
        } else if (errorMessage.contains("address") &&
            errorMessage
                .contains("Address must be between 10 and 255 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Address must be between 10 and 255 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("is required")) {
          _showSnackBar(
            title: 'Error',
            message: 'Make sure you entered all fields',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("job") &&
            errorMessage.contains("Job must be between 2 and 100 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Job must be between 2 and 100 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("email") &&
            errorMessage.contains("Invalid email format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid email format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("relativePhoneNumbers[0].phone") &&
            errorMessage.contains("Invalid phone number format")) {
          _showSnackBar(
            title: 'Error',
            message: 'Invalid phone number format',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("relativePhoneNumbers[0].phone") &&
            errorMessage
                .contains("phone number can't be less than 8 or exceeded 11")) {
          _showSnackBar(
            title: 'Error',
            message:
                'Relative phone number can\'t be less than 8 or exceeded 11',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("relativePhoneNumbers[0].relation") &&
            errorMessage
                .contains("Relation must be between 2 and 50 characters")) {
          _showSnackBar(
            title: 'Error',
            message: 'Relation must be between 2 and 50 characters',
            contentType: ContentType.failure,
          );
        } else if (errorMessage.contains("user.password") &&
            errorMessage.contains(
                "Password must contain at least one digit, one lowercase, one uppercase letter, one special character, and no whitespace")) {
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
        } else if (errorMessage.contains("user.userPhoneNumbers[0].phone") &&
            errorMessage
                .contains("phone number can't be less than 8 or exceeded 11")) {
          _showSnackBar(
            title: 'Error',
            message: 'User phone number can\'t be less than 8 or exceeded 11',
            contentType: ContentType.failure,
          );
        }
      }
    } else {
      _showSnackBar(
        title: 'Error',
        message: 'Failed to Update Owner: Make sure you entered all fields',
        contentType: ContentType.failure,
      );
    }
    setState(() => isLoading = false);
  }
}
