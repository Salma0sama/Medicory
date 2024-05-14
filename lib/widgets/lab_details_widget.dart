import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_lab_model.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class LabDetails extends StatefulWidget {
  const LabDetails({
    Key? key,
    required this.getLabModel,
  }) : super(key: key);
  final GetLabModel getLabModel;

  @override
  State<LabDetails> createState() => _LabDetailsState();
}

class _LabDetailsState extends State<LabDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'Name : ', value: widget.getLabModel.name),
      RowData(
          label: 'Google Maps Link : ',
          value: widget.getLabModel.googleMapsLink),
      RowData(label: 'Address : ', value: widget.getLabModel.address),
      RowData(label: 'Owner Name : ', value: widget.getLabModel.ownerName),
      RowData(label: 'Code : ', value: widget.getLabModel.code),
      RowData(label: 'Email : ', value: widget.getLabModel.email),
      RowData(label: 'Password : ', value: widget.getLabModel.password),
      RowData(label: 'Role : ', value: widget.getLabModel.role),
      RowData(label: 'phone : ', value: widget.getLabModel.userPhoneNumbers[0]),
      RowData(label: 'Enabled : ', value: widget.getLabModel.enabled),
    ];
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                        return Button(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return EditOwnerView(
                            //           getOwnerModel: widget.getOwnerModel,
                            //           relativePhoneNumber:
                            //               widget.relativePhoneNumber,
                            //           userDetail: widget.userDetail,
                            //           userPhoneNumber: widget.userPhoneNumber);
                            //     },
                            //   ),
                            // );
                          },
                          text: "Edit",
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
