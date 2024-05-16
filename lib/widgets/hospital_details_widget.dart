import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/views/edit_hospital_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class HospitalDetails extends StatefulWidget {
  const HospitalDetails({
    Key? key,
    required this.getHospitalModel,
  }) : super(key: key);
  final GetHospitalModel getHospitalModel;

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'Name : ', value: widget.getHospitalModel.name),
      RowData(
          label: 'Google Maps Link : ',
          value: widget.getHospitalModel.googleMapsLink),
      RowData(label: 'Address : ', value: widget.getHospitalModel.address),
      RowData(label: 'Code : ', value: widget.getHospitalModel.code),
      RowData(label: 'Email : ', value: widget.getHospitalModel.email),
      RowData(label: 'Password : ', value: widget.getHospitalModel.password),
      RowData(label: 'Role : ', value: widget.getHospitalModel.role),
      RowData(
          label: 'phone : ',
          value: widget.getHospitalModel.userPhoneNumbers[0]),
      RowData(label: 'Enabled : ', value: widget.getHospitalModel.enabled),
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditHospitalView(
                                          getHospitalModel:
                                              widget.getHospitalModel);
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
                                      "http://10.0.2.2:8081/admin/hosbitals/id/${widget.getHospitalModel.id}"),
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
