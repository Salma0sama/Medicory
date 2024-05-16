import 'package:flutter/material.dart';
import 'package:medicory/models/get_clinic_model.dart';
import 'package:medicory/services/edit_clinic_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditClinicView extends StatefulWidget {
  const EditClinicView({
    Key? key,
    required this.getClinicModel,
  }) : super(key: key);

  final GetClinicModel getClinicModel;

  @override
  State<EditClinicView> createState() => _EditClinicViewState();
}

class _EditClinicViewState extends State<EditClinicView> {
  late GetClinicModel getClinicModel;

  late TextEditingController _nameController;
  late TextEditingController _googleMapsLinkController;
  late TextEditingController _addressController;
  late TextEditingController _ownerNameController;
  late TextEditingController _specializationController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNumberController;

  String? name,
      googleMapsLink,
      address,
      ownerName,
      specialization,
      code,
      email,
      password,
      role,
      phone;

  bool? enabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getClinicModel = widget.getClinicModel;

    _nameController = TextEditingController(text: getClinicModel.name);
    _googleMapsLinkController =
        TextEditingController(text: getClinicModel.googleMapsLink);
    _addressController = TextEditingController(text: getClinicModel.address);
    _ownerNameController =
        TextEditingController(text: getClinicModel.ownerName);
    _specializationController =
        TextEditingController(text: getClinicModel.specialization);
    _userCodeController = TextEditingController(text: getClinicModel.code);
    _userEmailController = TextEditingController(text: getClinicModel.email);
    _userPasswordController =
        TextEditingController(text: getClinicModel.password);
    _userRoleController = TextEditingController(text: getClinicModel.role);
    _userPhoneNumberController =
        TextEditingController(text: getClinicModel.userPhoneNumbers[0]);
    enabled = getClinicModel.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Edit Clinic",
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
                label: "Owner Name :",
                controller: _ownerNameController,
                onchange: (data) {
                  ownerName = data;
                },
                hintText: 'Enter Owner Name',
              ),
              EditDetails(
                label: "Specialization :",
                controller: _specializationController,
                onchange: (data) {
                  specialization = data;
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
      final editClinicService = EditClinicService();
      GetClinicModel clinic = await editClinicService.EditClinic(
          id: getClinicModel.id,
          name: name ?? getClinicModel.name,
          googleMapsLink: googleMapsLink ?? getClinicModel.googleMapsLink,
          address: address ?? getClinicModel.address,
          ownerName: ownerName ?? getClinicModel.ownerName,
          specialization: specialization ?? getClinicModel.specialization,
          code: code ?? getClinicModel.code,
          email: email ?? getClinicModel.email,
          password: password ?? getClinicModel.password,
          role: role ?? getClinicModel.role,
          userPhoneNumbers: [phone ?? getClinicModel.userPhoneNumbers[0]],
          enabled: enabled ?? getClinicModel.enabled);
      print("CLinic edit successfully");
    } catch (error) {
      print("Failed to edit Clinic: $error");
    }
  }
}
