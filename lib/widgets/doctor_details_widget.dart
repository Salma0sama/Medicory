import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_doctor_model.dart';
import 'package:medicory/views/edit_doctor_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({
    Key? key,
    required this.getDoctorModel,
  }) : super(key: key);
  final GetDoctorModel getDoctorModel;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'First Name : ', value: widget.getDoctorModel.firstName),
      RowData(label: 'Middle Name : ', value: widget.getDoctorModel.middleName),
      RowData(label: 'Last Name : ', value: widget.getDoctorModel.lastName),
      RowData(
          label: 'Specialization : ',
          value: widget.getDoctorModel.specialization),
      RowData(
          label: 'Licence Number : ',
          value: widget.getDoctorModel.licenceNumber),
      RowData(label: 'National ID : ', value: widget.getDoctorModel.nationalId),
      RowData(
          label: 'Marital Status : ',
          value: widget.getDoctorModel.maritalStatus),
      RowData(label: 'Gender : ', value: widget.getDoctorModel.gender),
      RowData(label: 'Code : ', value: widget.getDoctorModel.code),
      RowData(label: 'Email : ', value: widget.getDoctorModel.email),
      RowData(label: 'Password : ', value: widget.getDoctorModel.password),
      RowData(label: 'Role : ', value: widget.getDoctorModel.role),
      RowData(
          label: 'phone : ', value: widget.getDoctorModel.userPhoneNumbers[0]),
      RowData(label: 'Enabled : ', value: widget.getDoctorModel.enabled),
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
                                      return EditDoctorView(
                                          getDoctorModel:
                                              widget.getDoctorModel);
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
                                      "http://10.0.2.2:8081/admin/doctors/id/${widget.getDoctorModel.id}"),
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
