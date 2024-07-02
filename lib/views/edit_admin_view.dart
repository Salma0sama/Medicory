import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_admin_model.dart';
import 'package:medicory/services/edit_admin_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditAdminView extends StatefulWidget {
  const EditAdminView({
    Key? key,
    required this.getAdminModel,
  }) : super(key: key);

  final GetAdminModel getAdminModel;

  @override
  State<EditAdminView> createState() => _EditAdminViewState();
}

class _EditAdminViewState extends State<EditAdminView> {
  late GetAdminModel getAdminModel;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNumberController;

  String? valueChooseGender;
  String? valueChooseMaritalStatus;

  String? firstName,
      lastName,
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
  void initState() {
    super.initState();
    getAdminModel = widget.getAdminModel;

    _firstNameController = TextEditingController(text: getAdminModel.firstName);
    _lastNameController = TextEditingController(text: getAdminModel.lastName);
    _userCodeController = TextEditingController(text: getAdminModel.code);
    _userEmailController = TextEditingController(text: getAdminModel.email);
    _userPasswordController =
        TextEditingController(text: getAdminModel.password);
    _userRoleController = TextEditingController(text: getAdminModel.role);
    _userPhoneNumberController =
        TextEditingController(text: getAdminModel.userPhoneNumbers[0]);
    enabled = getAdminModel.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Edit Admin",
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
                label: "First Name",
                controller: _firstNameController,
                onchange: (data) {
                  firstName = data;
                },
                hintText: 'Enter First Name',
              ),
              EditDetails(
                label: "Last Name",
                controller: _lastNameController,
                onchange: (data) {
                  lastName = data;
                },
                hintText: 'Enter Last Name',
              ),
              SliverToBoxAdapter(
                child: CustomDropdownButton(
                  addDropdownButton: AddDropdownButton(
                    label: "Gender",
                    hint: getAdminModel.gender,
                    items: genderOptions,
                    value: valueChooseGender,
                    onChanged: (data) {
                      setState(() {
                        valueChooseGender = data;
                      });
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: CustomDropdownButton(
                  addDropdownButton: AddDropdownButton(
                    label: "Marital Status",
                    hint: getAdminModel.maritalStatus,
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
                label: "Code",
                controller: _userCodeController,
                onchange: (data) {
                  code = data;
                },
                readonly: true,
                hintText: 'Enter Code',
              ),
              EditDetails(
                label: "Email",
                controller: _userEmailController,
                onchange: (data) {
                  email = data;
                },
                hintText: 'Enter Email',
              ),
              EditDetails(
                label: "Password",
                controller: _userPasswordController,
                onchange: (data) {
                  password = data;
                },
                hintText: 'Enter Password',
              ),
              EditDetails(
                label: "Role",
                controller: _userRoleController,
                onchange: (data) {
                  role = data;
                },
                readonly: true,
                hintText: 'Enter Role',
              ),
              EditDetails(
                label: "Phone",
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
                      SizedBox(
                        child: Text(
                          "Enabled",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      // Text(
                      //   ":",
                      //   style: TextStyle(
                      //     fontSize: 19,
                      //     color: kPrimaryColor,
                      //   ),
                      // ),
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
      final editAdminService = EditAdminService();
      GetAdminModel admin = await editAdminService.EditAdmin(
          id: getAdminModel.id,
          firstName: firstName ?? getAdminModel.firstName,
          lastName: lastName ?? getAdminModel.lastName,
          maritalStatus:
              valueChooseMaritalStatus ?? getAdminModel.maritalStatus,
          gender: valueChooseGender ?? getAdminModel.gender,
          code: code ?? getAdminModel.code,
          email: email ?? getAdminModel.email,
          password: password ?? getAdminModel.password,
          role: role ?? getAdminModel.role,
          userPhoneNumbers: [phone ?? getAdminModel.userPhoneNumbers[0]],
          enabled: enabled ?? getAdminModel.enabled);
      print("Admin edit successfully");
    } catch (error) {
      print("Failed to edit Admin: $error");
    }
  }
}
