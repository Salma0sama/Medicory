import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/services/edit_owner_service.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/edit_details_widget.dart';
import 'package:medicory/widgets/save_button_widget.dart';

class EditOwnerView extends StatefulWidget {
  const EditOwnerView({
    Key? key,
    required this.getOwnerModel,
    required this.relativePhoneNumber,
    required this.userDetail,
    required this.userPhoneNumber,
  }) : super(key: key);

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
  late TextEditingController _dateOfBirthController;
  late TextEditingController _addressController;
  late TextEditingController _nationalIdController;
  late TextEditingController _jobController;
  late TextEditingController _relativePhoneController;
  late TextEditingController _relativeRelationController;
  late TextEditingController _userCodeController;
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userRoleController;
  late TextEditingController _userPhoneNumberController;

  String? valueChooseGender;
  String? valueChooseBloodType;
  String? valueChooseMaritalStatus;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> genderOptions = ["MALE", "FEMALE"]; // Data from API
  List<String> bloodTypeOptions = [
    "A_POSITIVE",
    "A_NEGATIVE",
    "B_POSITIVE",
    "B_NEGATIVE",
    "AB_POSITIVE",
    "AB_NEGATIVE",
    "O_POSITIVE",
    "O_NEGATIVE"
  ]; // Data from API
  List<String> maritalStatusOptions = [
    "SINGLE",
    "MARRIED",
    "DIVORCED",
    "WIDOWED"
  ]; // Data from API

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
    _dateOfBirthController =
        TextEditingController(text: getOwnerModel.dateOfBirth);
    _addressController = TextEditingController(text: getOwnerModel.address);
    _nationalIdController =
        TextEditingController(text: '${getOwnerModel.nationalId}');
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
    enabled = userDetail.enabled;
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
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16),
      //   child: Form(
      //     key: _formKey,
      //     child: CustomScrollView(
      //       physics: BouncingScrollPhysics(),
      //       slivers: [
      //         EditDetails(
      //           label: "First Name :",
      //           controller: _firstNameController,
      //           onchange: (data) {
      //             firstName = data;
      //           },
      //           hintText: 'Enter First Name',
      //         ),
      //         EditDetails(
      //           label: "Maiden Name :",
      //           controller: _middleNameController,
      //           onchange: (data) {
      //             middleName = data;
      //           },
      //           hintText: 'Enter Middle Name',
      //         ),
      //         EditDetails(
      //           label: "Last Name :",
      //           controller: _lastNameController,
      //           onchange: (data) {
      //             lastName = data;
      //           },
      //           hintText: 'Enter Last Name',
      //         ),
      //         SliverToBoxAdapter(
      //           child: CustomDropdownButton(
      //             addDropdownButton: AddDropdownButton(
      //               label: "Gender :",
      //               hint: getOwnerModel.gender,
      //               items: genderOptions,
      //               value: valueChooseGender,
      //               onChanged: (data) {
      //                 setState(() {
      //                   valueChooseGender =
      //                       data; // Update state variable directly
      //                 });
      //               },
      //             ),
      //           ),
      //         ),
      //         EditDetails(
      //           label: "Date Of Birth :",
      //           controller: _dateOfBirthController,
      //           onchange: (data) {
      //             dateOfBirth = data;
      //           },
      //           hintText: 'Enter Date Of Birth',
      //         ),
      //         EditDetails(
      //           label: "Address :",
      //           controller: _addressController,
      //           onchange: (data) {
      //             address = data;
      //           },
      //           hintText: 'Enter Address',
      //         ),
      //         SliverToBoxAdapter(
      //           child: CustomDropdownButton(
      //             addDropdownButton: AddDropdownButton(
      //               label: "Blood Type :",
      //               hint: getOwnerModel.bloodType,
      //               items: bloodTypeOptions,
      //               value: valueChooseBloodType,
      //               onChanged: (data) {
      //                 setState(() {
      //                   valueChooseBloodType = data;
      //                 });
      //               },
      //             ),
      //           ),
      //         ),
      //         EditDetails(
      //           label: "National ID :",
      //           controller: _nationalIdController,
      //           onchange: (data) {
      //             nationalId = data;
      //           },
      //           readonly: true,
      //           hintText: 'Enter National ID',
      //         ),
      //         SliverToBoxAdapter(
      //           child: CustomDropdownButton(
      //             addDropdownButton: AddDropdownButton(
      //               label: "Marital Status :",
      //               hint: getOwnerModel.maritalStatus,
      //               items: maritalStatusOptions,
      //               value: valueChooseMaritalStatus,
      //               onChanged: (data) {
      //                 setState(() {
      //                   valueChooseMaritalStatus = data;
      //                 });
      //               },
      //             ),
      //           ),
      //         ),
      //         EditDetails(
      //           label: "Job :",
      //           controller: _jobController,
      //           onchange: (data) {
      //             job = data;
      //           },
      //           hintText: 'Enter Job',
      //         ),
      //         EditDetails(
      //           label: "Relative Phone :",
      //           controller: _relativePhoneController,
      //           onchange: (data) {
      //             relativePhone = data;
      //           },
      //           hintText: 'Enter Relative Phone',
      //         ),
      //         EditDetails(
      //           label: "Relative Relation :",
      //           controller: _relativeRelationController,
      //           onchange: (data) {
      //             relativeRelation = data;
      //           },
      //           hintText: 'Enter Relative Relation',
      //         ),
      //         EditDetails(
      //           label: "User Code :",
      //           controller: _userCodeController,
      //           onchange: (data) {
      //             code = data;
      //           },
      //           readonly: true,
      //           hintText: 'Enter User Code',
      //         ),
      //         EditDetails(
      //           label: "User Email :",
      //           controller: _userEmailController,
      //           onchange: (data) {
      //             email = data;
      //           },
      //           hintText: 'Enter User Email',
      //         ),
      //         EditDetails(
      //           label: "User Password :",
      //           controller: _userPasswordController,
      //           onchange: (data) {
      //             password = data;
      //           },
      //           hintText: 'Enter User Password',
      //         ),
      //         EditDetails(
      //           label: "User Role :",
      //           controller: _userRoleController,
      //           onchange: (data) {
      //             role = data;
      //           },
      //           readonly: true,
      //           hintText: 'Enter User Role',
      //         ),
      //         EditDetails(
      //           label: "User Phone :",
      //           controller: _userPhoneNumberController,
      //           onchange: (data) {
      //             phone = data;
      //           },
      //           hintText: 'Enter User Phone',
      //         ),
      //         SliverToBoxAdapter(
      //           child: Padding(
      //             padding: const EdgeInsets.only(top: 5),
      //             child: Row(
      //               children: [
      //                 Text(
      //                   "Enabled :",
      //                   style: TextStyle(
      //                     fontSize: 19,
      //                     color: kPrimaryColor,
      //                   ),
      //                 ),
      //                 SizedBox(width: 10),
      //                 Radio<bool>(
      //                   value: true,
      //                   groupValue: enabled,
      //                   onChanged: (value) {
      //                     setState(() {
      //                       enabled = value;
      //                     });
      //                   },
      //                 ),
      //                 Text(
      //                   'True',
      //                   style: TextStyle(fontSize: 16),
      //                 ),
      //                 SizedBox(width: 20),
      //                 Radio<bool>(
      //                   value: false,
      //                   groupValue: enabled,
      //                   onChanged: (value) {
      //                     setState(() {
      //                       enabled = value;
      //                     });
      //                   },
      //                 ),
      //                 Text(
      //                   'False',
      //                   style: TextStyle(fontSize: 16),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         SliverToBoxAdapter(
      //           child: SaveButton(
      //             onPressed: () {
      //               if (_formKey.currentState!.validate()) {
      //                 _formKey.currentState!.save();
      //                 submitData(context);
      //               }
      //             },
      //             text: "Save",
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  void submitData(BuildContext context) async {
    try {
      final editOwnerService = EditOwnerService();
      GetOwnerModel owner = await editOwnerService.EditOwner(
        id: getOwnerModel.id,
        firstName: firstName ?? getOwnerModel.firstName,
        middleName: middleName ?? getOwnerModel.middleName,
        lastName: lastName ?? getOwnerModel.lastName,
        gender: valueChooseGender ?? getOwnerModel.gender,
        dateOfBirth: dateOfBirth ?? getOwnerModel.dateOfBirth,
        address: address ?? getOwnerModel.address,
        bloodType: valueChooseBloodType ?? getOwnerModel.bloodType,
        nationalId: int.parse(getOwnerModel.nationalId.toString()),
        maritalStatus: valueChooseMaritalStatus ?? getOwnerModel.maritalStatus,
        job: job ?? getOwnerModel.job,
        relativePhoneNumbers: [
          RelativePhoneNumber(
              id: widget.relativePhoneNumber.id,
              phone: relativePhone ?? widget.relativePhoneNumber.phone,
              relation: relativeRelation ?? widget.relativePhoneNumber.relation)
        ],
        user: UserDetail(
          code: widget.userDetail.code,
          email: email ?? widget.userDetail.email,
          password: password ?? widget.userDetail.password,
          role: widget.userDetail.role,
          userPhoneNumbers: [
            UserPhoneNumber(
                id: widget.userPhoneNumber.id,
                phone: phone ?? widget.userPhoneNumber.phone)
          ],
          enabled: enabled ?? widget.userDetail.enabled,
        ),
      );
      print("Owner edit successfully");
    } catch (error) {
      print("Failed to edit owner: $error");
    }
  }
}
