import 'package:flutter/material.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/services/edit_hospital_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditHospitalView extends StatefulWidget {
  const EditHospitalView({
    Key? key,
    required this.getHospitalModel,
  }) : super(key: key);

  final GetHospitalModel getHospitalModel;

  @override
  State<EditHospitalView> createState() => _EditHospitalViewState();
}

class _EditHospitalViewState extends State<EditHospitalView> {
  late GetHospitalModel getHospitalModel;

  late TextEditingController _nameController;
  late TextEditingController _googleMapsLinkController;
  late TextEditingController _addressController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNunmerController;

  String? name, googleMapsLink, address, code, email, password, role, phone;

  bool? enabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getHospitalModel = widget.getHospitalModel;

    _nameController = TextEditingController(text: getHospitalModel.name);
    _googleMapsLinkController =
        TextEditingController(text: getHospitalModel.googleMapsLink);
    _addressController = TextEditingController(text: getHospitalModel.address);
    _userCodeController = TextEditingController(text: getHospitalModel.code);
    _userEmailController = TextEditingController(text: getHospitalModel.email);
    _userPasswordController =
        TextEditingController(text: getHospitalModel.password);
    _userRoleController = TextEditingController(text: getHospitalModel.role);
    _userPhoneNunmerController =
        TextEditingController(text: getHospitalModel.userPhoneNumbers[0]);
    enabled = getHospitalModel.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Edit Hospital",
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
                label: "Name :",
                controller: _nameController,
                onchange: (data) {
                  name = data;
                },
                hintText: 'Enter Name',
              ),
              EditDetails(
                label: "Google Maps Link :",
                controller: _googleMapsLinkController,
                onchange: (data) {
                  googleMapsLink = data;
                },
                hintText: 'Enter Google Maps Link',
              ),
              EditDetails(
                label: "Address :",
                controller: _addressController,
                onchange: (data) {
                  address = data;
                },
                hintText: 'Enter Address',
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
                label: "User Email :",
                controller: _userEmailController,
                onchange: (data) {
                  email = data;
                },
                hintText: 'Enter Email',
              ),
              EditDetails(
                label: "User Password :",
                controller: _userPasswordController,
                onchange: (data) {
                  password = data;
                },
                hintText: 'Enter Password',
              ),
              EditDetails(
                label: "User Role :",
                controller: _userRoleController,
                onchange: (data) {
                  role = data;
                },
                readonly: true,
                hintText: 'Enter Role',
              ),
              EditDetails(
                label: "Phone :",
                controller: _userPhoneNunmerController,
                onchange: (data) {
                  phone = data;
                },
                hintText: 'Enter Phone Number',
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
      final editHospitalService = EditHospitalService();
      GetHospitalModel hospital = await editHospitalService.EditHospital(
          id: getHospitalModel.id,
          name: name ?? getHospitalModel.name,
          googleMapsLink: googleMapsLink ?? getHospitalModel.googleMapsLink,
          address: address ?? getHospitalModel.address,
          code: code ?? getHospitalModel.code,
          email: email ?? getHospitalModel.email,
          password: password ?? getHospitalModel.password,
          role: role ?? getHospitalModel.role,
          userPhoneNumbers: [phone ?? getHospitalModel.userPhoneNumbers[0]],
          enabled: enabled ?? getHospitalModel.enabled);
      print("Hospital edit successfully");
    } catch (error) {
      print("Failed to edit Hospital: $error");
    }
  }
}
