import 'package:flutter/material.dart';
import 'package:medicory/models/add_new_owner_model.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/services/add_new_owner_service.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/custom_dropdownbutton_widget.dart';
import 'package:medicory/widgets/custom_textfield_widget.dart';

class AddOwnerView extends StatefulWidget {
  const AddOwnerView({super.key});

  @override
  State<AddOwnerView> createState() => _AddOwnerViewState();
}

class _AddOwnerViewState extends State<AddOwnerView> {
  String? valueChooseGender;
  String? valueChooseBloodType;
  String? valueChooseMaritalStatus;
  String? valueChooseRole;
  bool? valueChooseEnabled;

  String? firstName,
      middleName,
      lastName,
      dateOfBirth,
      address,
      job,
      email,
      phone,
      relativePhone,
      relativeRelation;

  int? nationalId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Add Owner",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.only(left: 16, right: 16),
      //   child: Container(
      //     width: MediaQuery.of(context).size.width,
      //     child: Form(
      //       key: _formKey,
      //       child: SingleChildScrollView(
      //         physics: BouncingScrollPhysics(),
      //         child: Column(
      //           children: [
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => firstName = data),
      //                 Label: "First Name :",
      //                 hintText: "First Name",
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => middleName = data),
      //                 Label: "Middle Name :",
      //                 hintText: "Middle Name",
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => lastName = data),
      //                 Label: "Last Name :",
      //                 hintText: "Last Name",
      //               ),
      //             ),
      //             CustomDropdownButton(
      //               addDropdownButton: AddDropdownButton(
      //                   label: "Gender :",
      //                   hint: "Select Gender",
      //                   items: ["MALE", "FEMALE"],
      //                   value: valueChooseGender,
      //                   onChanged: (data) {
      //                     setState(() {
      //                       valueChooseGender = data;
      //                     });
      //                   }),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => dateOfBirth = data),
      //                 Label: "Date Of Birth :",
      //                 hintText: "Date Of Birth",
      //                 keyboardType: TextInputType.datetime,
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => address = data),
      //                 Label: "Address :",
      //                 hintText: "Address",
      //               ),
      //             ),
      //             CustomDropdownButton(
      //               addDropdownButton: AddDropdownButton(
      //                   label: "Blood Type :",
      //                   hint: "Select Blood Type",
      //                   items: [
      //                     "A_POSITIVE",
      //                     "A_NEGATIVE",
      //                     "B_POSITIVE",
      //                     "B_NEGATIVE",
      //                     "AB_POSITIVE",
      //                     "AB_NEGATIVE",
      //                     "O_POSITIVE",
      //                     "O_NEGATIVE"
      //                   ],
      //                   value: valueChooseBloodType,
      //                   onChanged: (data) {
      //                     setState(() {
      //                       valueChooseBloodType = data;
      //                     });
      //                   }),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) =>
      //                     setState(() => nationalId = int.tryParse(data)),
      //                 Label: "National ID :",
      //                 hintText: "National ID",
      //                 keyboardType: TextInputType.number,
      //               ),
      //             ),
      //             CustomDropdownButton(
      //               addDropdownButton: AddDropdownButton(
      //                   label: "Marital Status :",
      //                   hint: "Select Marital Status",
      //                   items: ["SINGLE", "MARRIED", "DIVORCED", "WIDOWED"],
      //                   value: valueChooseMaritalStatus,
      //                   onChanged: (data) {
      //                     setState(() {
      //                       valueChooseMaritalStatus = data;
      //                     });
      //                   }),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => job = data),
      //                 Label: "Job :",
      //                 hintText: "Job",
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => relativePhone = data),
      //                 Label: "Relative Phone :",
      //                 hintText: "Relative Phone",
      //                 keyboardType: TextInputType.phone,
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) =>
      //                     setState(() => relativeRelation = data),
      //                 Label: "Relative Relation :",
      //                 hintText: "Relative Relation",
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => email = data),
      //                 Label: "User Email :",
      //                 hintText: "User Email",
      //               ),
      //             ),
      //             CustomTextField(
      //               addTextField: AddTextField(
      //                 onchange: (data) => setState(() => phone = data),
      //                 Label: "User Phone :",
      //                 hintText: "User Phone",
      //                 keyboardType: TextInputType.phone,
      //               ),
      //             ),
      //             Button(
      //               text: "Submit",
      //               onPressed: () {
      //                 if (_formKey.currentState!.validate()) {
      //                   _formKey.currentState!.save();
      //                   submitData(context);
      //                 }
      //               },
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void submitData(BuildContext context) async {
    try {
      final addOwnerService = AddNewOwnerService();
      AddNewOwnerModel owner = await addOwnerService.addNewOwner(
        firstName: firstName!,
        middleName: middleName!,
        lastName: lastName!,
        gender: valueChooseGender!,
        dateOfBirth: dateOfBirth!,
        address: address!,
        bloodType: valueChooseBloodType!,
        nationalId: nationalId!,
        maritalStatus: valueChooseMaritalStatus!,
        job: job!,
        relativePhoneNumbers: [
          RelativePhoneNumber(
              phone: relativePhone!, relation: relativeRelation!)
        ],
        user: UserDetail(
          email: email!,
          role: "OWNER",
          userPhoneNumbers: [UserPhoneNumber(phone: phone!)],
          enabled: true,
        ),
      );
      print("Owner added successfully: $owner");

      setState(() {
        firstName = null;
        middleName = null;
        lastName = null;
        valueChooseGender = null;
        dateOfBirth = null;
        address = null;
        valueChooseBloodType = null;
        nationalId = null;
        valueChooseMaritalStatus = null;
        job = null;
        relativePhone = null;
        relativeRelation = null;
        email = null;
        phone = null;
      });

      valueChooseGender = null;
      valueChooseBloodType = null;
      valueChooseMaritalStatus = null;

      _formKey.currentState?.reset();
    } catch (error) {
      print("Failed to add owner: $error");
    }
  }
}
