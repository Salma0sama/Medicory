import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_pharmacy_model.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class PharmacyDetails extends StatefulWidget {
  const PharmacyDetails({Key? key, required this.getPharmacyModel})
      : super(key: key);
  final GetPharmacyModel getPharmacyModel;

  @override
  State<PharmacyDetails> createState() => _PharmacyDetailsState();
}

class _PharmacyDetailsState extends State<PharmacyDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'Name : ', value: widget.getPharmacyModel.name),
      RowData(
          label: 'Google Maps Link : ',
          value: widget.getPharmacyModel.googleMapsLink),
      RowData(label: 'Address : ', value: widget.getPharmacyModel.address),
      RowData(label: 'Owner Name : ', value: widget.getPharmacyModel.ownerName),
      RowData(label: 'Code : ', value: widget.getPharmacyModel.code),
      RowData(label: 'Email : ', value: widget.getPharmacyModel.email),
      RowData(label: 'Password : ', value: widget.getPharmacyModel.password),
      RowData(label: 'Role : ', value: widget.getPharmacyModel.role),
      RowData(
          label: 'phone : ',
          value: widget.getPharmacyModel.userPhoneNumbers[0]),
      RowData(label: 'Enabled : ', value: widget.getPharmacyModel.enabled),
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
