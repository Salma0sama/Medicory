import 'package:flutter/material.dart';
import 'package:medicory/models/edit_owner_model.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/services/edit_owner_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditOwnerView extends StatefulWidget {
  const EditOwnerView(
      {Key? key,
      required this.getOwnerModel,
      required this.relativePhoneNumber,
      required this.userDetail,
      required this.userPhoneNumber})
      : super(key: key);

  final GetOwnerModel getOwnerModel;
  final RelativePhoneNumber relativePhoneNumber;
  final UserDetail userDetail;
  final UserPhoneNumber userPhoneNumber;

  @override
  State<EditOwnerView> createState() => _EditOwnerViewState();
}

class _EditOwnerViewState extends State<EditOwnerView> {
  late GetOwnerModel getOwnerModel;
  late RelativePhoneNumber relativePhoneNumber;
  late UserDetail userDetail;
  late UserPhoneNumber userPhoneNumber;

  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _genderController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _addressController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _nationalIdController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _jobController;
  late TextEditingController _relativePhoneController;
  late TextEditingController _relativeRelationController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNumberController;
  late TextEditingController _enabledController;

  String? firstName,
      middleName,
      lastName,
      gender,
      dateOfBirth,
      address,
      bloodType,
      maritalStatus,
      job,
      code,
      email,
      password,
      role,
      phone,
      relativePhone,
      relativeRelation;

  int? nationalId;
  bool? enabled;
  final List<Map<String, String>> relativePhoneNumbers = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getOwnerModel = widget.getOwnerModel;
    relativePhoneNumber = widget.relativePhoneNumber;
    userDetail = widget.userDetail;
    userPhoneNumber = widget.userPhoneNumber;

    _firstNameController = TextEditingController(text: getOwnerModel.firstName);
    _middleNameController =
        TextEditingController(text: getOwnerModel.middleName);
    _lastNameController = TextEditingController(text: getOwnerModel.lastName);
    _genderController = TextEditingController(text: getOwnerModel.gender);
    _dateOfBirthController =
        TextEditingController(text: getOwnerModel.dateOfBirth);
    _addressController = TextEditingController(text: getOwnerModel.address);
    _bloodTypeController = TextEditingController(text: getOwnerModel.bloodType);
    _nationalIdController =
        TextEditingController(text: '${getOwnerModel.nationalId}');
    _maritalStatusController =
        TextEditingController(text: getOwnerModel.maritalStatus);
    _jobController = TextEditingController(text: getOwnerModel.job);
    _relativePhoneController =
        TextEditingController(text: relativePhoneNumber.phone);
    _relativeRelationController =
        TextEditingController(text: relativePhoneNumber.relation);
    _userCodeController = TextEditingController(text: userDetail.code);
    _userEmailController = TextEditingController(text: userDetail.email);
    _userPasswordController = TextEditingController(text: userDetail.password);
    _userRoleController = TextEditingController(text: userDetail.role);
    _userPhoneNumberController =
        TextEditingController(text: userPhoneNumber.phone);
    _enabledController =
        TextEditingController(text: userDetail.enabled.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Edit Owner",
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
                readonly: false,
                hintText: 'Enter First Name',
              ),
              EditDetails(
                label: "Maiden Name :",
                controller: _middleNameController,
                onchange: (data) {
                  middleName = data;
                },
                readonly: false,
                hintText: 'Enter Middle Name',
              ),
              EditDetails(
                label: "Last Name :",
                controller: _lastNameController,
                onchange: (data) {
                  lastName = data;
                },
                readonly: false,
                hintText: 'Enter Last Name',
              ),
              EditDetails(
                label: "Gender :",
                controller: _genderController,
                onchange: (data) {
                  gender = data;
                },
                readonly: false,
                hintText: 'Enter Gender',
              ),
              EditDetails(
                label: "Date Of Birth :",
                controller: _dateOfBirthController,
                onchange: (data) {
                  dateOfBirth = data;
                },
                readonly: false,
                hintText: 'Enter Date Of Birth',
              ),
              EditDetails(
                label: "Address :",
                controller: _addressController,
                onchange: (data) {
                  address = data;
                },
                readonly: false,
                hintText: 'Enter Address',
              ),
              EditDetails(
                label: "Blood Type :",
                controller: _bloodTypeController,
                onchange: (data) {
                  bloodType = data;
                },
                readonly: false,
                hintText: 'Enter Blood Type',
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
              EditDetails(
                label: "Marital Status :",
                controller: _maritalStatusController,
                onchange: (data) {
                  maritalStatus = data;
                },
                readonly: false,
                hintText: 'Enter Marital Status',
              ),
              EditDetails(
                label: "Job :",
                controller: _jobController,
                onchange: (data) {
                  job = data;
                },
                readonly: false,
                hintText: 'Enter Job',
              ),
              EditDetails(
                label: "Relative Phone :",
                controller: _relativePhoneController,
                onchange: (data) {
                  relativePhone = data;
                },
                readonly: false,
                hintText: 'Enter Relative Phone',
              ),
              EditDetails(
                label: "Relative Relation :",
                controller: _relativeRelationController,
                onchange: (data) {
                  relativeRelation = data;
                },
                readonly: false,
                hintText: 'Enter Relative Relation',
              ),
              EditDetails(
                label: "User Code :",
                controller: _userCodeController,
                onchange: (data) {
                  code = data;
                },
                readonly: true,
                hintText: 'Enter User Code',
              ),
              EditDetails(
                label: "User Email :",
                controller: _userEmailController,
                onchange: (data) {
                  email = data;
                },
                readonly: false,
                hintText: 'Enter User Email',
              ),
              EditDetails(
                label: "User Password :",
                controller: _userPasswordController,
                onchange: (data) {
                  password = data;
                },
                readonly: false,
                hintText: 'Enter User Password',
              ),
              EditDetails(
                label: "User Role :",
                controller: _userRoleController,
                onchange: (data) {
                  role = data;
                },
                readonly: false,
                hintText: 'Enter User Role',
              ),
              EditDetails(
                label: "User Phone :",
                controller: _userPhoneNumberController,
                onchange: (data) {
                  phone = data;
                },
                readonly: false,
                hintText: 'Enter User Phone',
              ),
              EditDetails(
                label: "Enabled :",
                controller: _enabledController,
                onchange: (data) {
                  enabled = data.toLowerCase() == 'true';
                },
                readonly: false,
                hintText: 'Enter Enabled',
              ),
              SliverToBoxAdapter(
                child: SaveButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        submitData(context);
                      }
                    },
                    text: "Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitData(BuildContext context) async {
    try {
      final editOwnerService = EditOwnerService();
      EditOwnerModel owner = await editOwnerService.EditOwner(
        id: getOwnerModel.id,
        firstName: firstName ?? _firstNameController.text,
        middleName: middleName ?? _middleNameController.text,
        lastName: lastName ?? _lastNameController.text,
        gender: gender ?? _genderController.text,
        dateOfBirth: dateOfBirth ?? _dateOfBirthController.text,
        address: address ?? _addressController.text,
        bloodType: bloodType ?? _bloodTypeController.text,
        nationalId: nationalId ?? int.parse(_nationalIdController.text),
        maritalStatus: maritalStatus ?? _maritalStatusController.text,
        job: job ?? _jobController.text,
        relativePhoneNumbers: [
          RelativePhoneNumbers(
              phone: relativePhone ?? _relativePhoneController.text,
              relation: relativeRelation ?? _relativeRelationController.text)
        ],
        user: UserDetails(
          code: code ?? _userCodeController.text,
          email: email ?? _userEmailController.text,
          password: password ?? _userPasswordController.text,
          role: role ?? _userRoleController.text,
          userPhoneNumbers: [
            UserPhoneNumbers(phone: phone ?? _userPhoneNumberController.text)
          ],
          enabled: enabled ?? (_enabledController.text.toLowerCase() == 'true'),
        ),
      );
      print("Owner edit successfully");
    } catch (error) {
      print("Failed to edit owner: $error");
    }
  }
}
