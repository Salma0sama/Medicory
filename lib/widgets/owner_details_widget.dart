import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/views/edit_owner_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class OwnerDetails extends StatefulWidget {
  const OwnerDetails(
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
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'First Name : ', value: widget.getOwnerModel.firstName),
      RowData(label: 'Middle Name : ', value: widget.getOwnerModel.middleName),
      RowData(label: 'Last Name : ', value: widget.getOwnerModel.lastName),
      RowData(label: 'Gender : ', value: widget.getOwnerModel.gender),
      RowData(
          label: 'Date Of Birth : ', value: widget.getOwnerModel.dateOfBirth),
      RowData(label: 'Address : ', value: widget.getOwnerModel.address),
      RowData(label: 'Blood Type : ', value: widget.getOwnerModel.bloodType),
      RowData(label: 'National ID : ', value: widget.getOwnerModel.nationalId),
      RowData(
          label: 'Marital Status : ',
          value: widget.getOwnerModel.maritalStatus),
      RowData(label: 'Job : ', value: widget.getOwnerModel.job),
      RowData(
          label: 'Relative Phone : ', value: widget.relativePhoneNumber.phone),
      RowData(
          label: 'Relative relation : ',
          value: widget.relativePhoneNumber.relation),
      RowData(label: 'User Code : ', value: widget.userDetail.code),
      RowData(label: 'User Email : ', value: widget.userDetail.email),
      RowData(label: 'User Password : ', value: widget.userDetail.password),
      RowData(label: 'User Role : ', value: widget.userDetail.role),
      RowData(label: 'User phone : ', value: widget.userPhoneNumber.phone),
      RowData(label: 'Enabled : ', value: widget.userDetail.enabled),
    ];
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: rowData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < rowData.length) {
                        return Column(
                          children: [
                            BuildRow(
                              rowData: RowData(
                                  label: rowData[index].label,
                                  value: rowData[index].value),
                            ),
                            BuildDivider(),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditOwnerView(
                                          getOwnerModel: widget.getOwnerModel,
                                          relativePhoneNumber:
                                              widget.relativePhoneNumber,
                                          userDetail: widget.userDetail,
                                          userPhoneNumber:
                                              widget.userPhoneNumber);
                                    },
                                  ),
                                );
                              },
                              text: "Edit",
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            Button(
                              onPressed: () async {
                                await http.delete(
                                  Uri.parse(
                                      "http://10.0.2.2:8081/admin/owners/id/${widget.getOwnerModel.id}"),
                                );
                              },
                              color: Colors.red,
                              text: "Delete",
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
