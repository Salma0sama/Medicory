import 'package:flutter/material.dart';
import 'package:medicory/models/get_pharmacy_model.dart';
import 'package:medicory/services/edit_pharmacy_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditPharmacyView extends StatefulWidget {
  const EditPharmacyView({
    Key? key,
    required this.getPharmacyModel,
  }) : super(key: key);

  final GetPharmacyModel getPharmacyModel;

  @override
  State<EditPharmacyView> createState() => _EditPharmacyViewState();
}

class _EditPharmacyViewState extends State<EditPharmacyView> {
  late GetPharmacyModel getPharmacyModel;

  late TextEditingController _nameController;
  late TextEditingController _googleMapsLinkController;
  late TextEditingController _addressController;
  late TextEditingController _ownerNameController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNunmerController;

  String? name,
      googleMapsLink,
      address,
      ownerName,
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
    getPharmacyModel = widget.getPharmacyModel;

    _nameController = TextEditingController(text: getPharmacyModel.name);
    _googleMapsLinkController =
        TextEditingController(text: getPharmacyModel.googleMapsLink);
    _addressController = TextEditingController(text: getPharmacyModel.address);
    _ownerNameController =
        TextEditingController(text: getPharmacyModel.ownerName);
    _userCodeController = TextEditingController(text: getPharmacyModel.code);
    _userEmailController = TextEditingController(text: getPharmacyModel.email);
    _userPasswordController =
        TextEditingController(text: getPharmacyModel.password);
    _userRoleController = TextEditingController(text: getPharmacyModel.role);
    _userPhoneNunmerController =
        TextEditingController(text: getPharmacyModel.userPhoneNumbers[0]);
    enabled = getPharmacyModel.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Edit Lab",
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
      final editPharmacyService = EditPharmacyService();
      GetPharmacyModel pharmacy = await editPharmacyService.EditPharmacy(
          id: getPharmacyModel.id,
          name: name ?? getPharmacyModel.name,
          googleMapsLink: googleMapsLink ?? getPharmacyModel.googleMapsLink,
          address: address ?? getPharmacyModel.address,
          ownerName: ownerName ?? getPharmacyModel.ownerName,
          code: code ?? getPharmacyModel.code,
          email: email ?? getPharmacyModel.email,
          password: password ?? getPharmacyModel.password,
          role: role ?? getPharmacyModel.role,
          userPhoneNumbers: [phone ?? getPharmacyModel.userPhoneNumbers[0]],
          enabled: enabled ?? getPharmacyModel.enabled);
      print("Pharmacy edit successfully");
    } catch (error) {
      print("Failed to edit Pharmacy: $error");
    }
  }
}
