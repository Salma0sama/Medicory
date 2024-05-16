import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_doctor_model.dart';
import 'package:medicory/services/edit_doctor_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditDoctorView extends StatefulWidget {
  const EditDoctorView({
    Key? key,
    required this.getDoctorModel,
  }) : super(key: key);

  final GetDoctorModel getDoctorModel;

  @override
  State<EditDoctorView> createState() => _EditDoctorViewState();
}

class _EditDoctorViewState extends State<EditDoctorView> {
  late GetDoctorModel getDoctorModel;

  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _specializationController;
  late TextEditingController _licenceNumberController;
  late TextEditingController _nationalIdController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNumberController;

  String? valueChooseGender;
  String? valueChooseMaritalStatus;

  String? firstName,
      middleName,
      lastName,
      specialization,
      licenceNumber,
      gender,
      maritalStatus,
      code,
      email,
      password,
      role,
      phone;

  int? nationalId;
  bool? enabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> genderOptions = ["MALE", "FEMALE"];

  List<String> maritalStatusOptions = [
    "SINGLE",
    "MARRIED",
    "DIVORCED",
    "WIDOWED"
  ]; // Data from API// Data from API

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
    _licenceNumberController =
        TextEditingController(text: getDoctorModel.licenceNumber);
    _nationalIdController =
        TextEditingController(text: '${getDoctorModel.nationalId}');
    _userCodeController = TextEditingController(text: getDoctorModel.code);
    _userEmailController = TextEditingController(text: getDoctorModel.email);
    _userPasswordController =
        TextEditingController(text: getDoctorModel.password);
    _userRoleController = TextEditingController(text: getDoctorModel.role);
    _userPhoneNumberController =
        TextEditingController(text: getDoctorModel.userPhoneNumbers[0]);
    enabled = getDoctorModel.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Edit Doctor",
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
              EditDetails(
                label: "First Name :",
                controller: _firstNameController,
                onchange: (data) {
                  firstName = data;
                },
                hintText: 'Enter First Name',
              ),
              EditDetails(
                label: "Maiden Name :",
                controller: _middleNameController,
                onchange: (data) {
                  middleName = data;
                },
                hintText: 'Enter Middle Name',
              ),
              EditDetails(
                label: "Last Name :",
                controller: _lastNameController,
                onchange: (data) {
                  lastName = data;
                },
                hintText: 'Enter Last Name',
              ),
              EditDetails(
                label: "Specialization :",
                controller: _specializationController,
                onchange: (data) {
                  specialization = data;
                },
                hintText: 'Enter Specialization',
              ),
              EditDetails(
                label: "Licence Number :",
                controller: _licenceNumberController,
                onchange: (data) {
                  licenceNumber = data;
                },
                hintText: 'Enter Licence Number',
              ),
              SliverToBoxAdapter(
                child: CustomDropdownButton(
                  addDropdownButton: AddDropdownButton(
                    label: "Gender :",
                    hint: getDoctorModel.gender,
                    items: genderOptions,
                    value: valueChooseGender,
                    onChanged: (data) {
                      setState(() {
                        valueChooseGender =
                            data; // Update state variable directly
                      });
                    },
                  ),
                ),
              ),
              EditDetails(
                label: "National ID :",
                controller: _nationalIdController,
                onchange: (data) {
                  nationalId = data;
                },
                readonly: true,
                hintText: 'Enter National ID',
              ),
              SliverToBoxAdapter(
                child: CustomDropdownButton(
                  addDropdownButton: AddDropdownButton(
                    label: "Marital Status :",
                    hint: getDoctorModel.maritalStatus,
                    items: maritalStatusOptions,
                    value: valueChooseMaritalStatus,
                    onChanged: (data) {
                      setState(() {
                        valueChooseMaritalStatus = data;
                      });
                    },
                  ),
                ),
              ),
              EditDetails(
                label: "Code :",
                controller: _userCodeController,
                onchange: (data) {
                  code = data;
                },
                readonly: true,
                hintText: 'Enter Code',
              ),
              EditDetails(
                label: "Email :",
                controller: _userEmailController,
                onchange: (data) {
                  email = data;
                },
                hintText: 'Enter Email',
              ),
              EditDetails(
                label: "Password :",
                controller: _userPasswordController,
                onchange: (data) {
                  password = data;
                },
                hintText: 'Enter Password',
              ),
              EditDetails(
                label: "Role :",
                controller: _userRoleController,
                onchange: (data) {
                  role = data;
                },
                readonly: true,
                hintText: 'Enter Role',
              ),
              EditDetails(
                label: "Phone :",
                controller: _userPhoneNumberController,
                onchange: (data) {
                  phone = data;
                },
                hintText: 'Enter Phone',
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text(
                        "Enabled :",
                        style: TextStyle(
                          fontSize: 19,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Radio<bool>(
                        value: true,
                        groupValue: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                      ),
                      Text(
                        'True',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 20),
                      Radio<bool>(
                        value: false,
                        groupValue: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                      ),
                      Text(
                        'False',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SaveButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      submitData(context);
                    }
                  },
                  text: "Save",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitData(BuildContext context) async {
    try {
      final editDoctorService = EditDoctorService();
      GetDoctorModel doctor = await editDoctorService.EditDoctor(
        id: getDoctorModel.id,
        firstName: firstName ?? getDoctorModel.firstName,
        middleName: middleName ?? getDoctorModel.middleName,
        lastName: lastName ?? getDoctorModel.lastName,
        licenceNumber: licenceNumber ?? getDoctorModel.licenceNumber,
        specialization: specialization ?? getDoctorModel.specialization,
        gender: valueChooseGender ?? getDoctorModel.gender,
        nationalId:
            nationalId ?? int.parse(getDoctorModel.nationalId.toString()),
        maritalStatus: valueChooseMaritalStatus ?? getDoctorModel.maritalStatus,
        code: code ?? getDoctorModel.code,
        email: email ?? getDoctorModel.email,
        password: password ?? getDoctorModel.password,
        role: role ?? getDoctorModel.role,
        userPhoneNumbers: [phone ?? getDoctorModel.userPhoneNumbers[0]],
        enabled: enabled ?? getDoctorModel.enabled,
      );
      print("Doctor edit successfully");
    } catch (error) {
      print("Failed to edit Doctor: $error");
    }
  }
}
