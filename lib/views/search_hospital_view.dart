import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_hospital_service.dart';
import 'package:medicory/views/hospital_details_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_hospital_container_widget.dart';

class SearchHospitalView extends StatefulWidget {
  const SearchHospitalView({Key? key}) : super(key: key);

  @override
  _SearchHospitalViewState createState() => _SearchHospitalViewState();
}

class _SearchHospitalViewState extends State<SearchHospitalView> {
  String searchText = "";
  String? searchWith;
  List<GetHospitalSearch> hospital = [];
  FocusNode _focusNode = FocusNode();
  String selectedButton = "";
  bool isLoading = false;
  bool isButtonPressed = false;
  bool showErrorDialog = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void selectButton(String buttonName) {
    setState(() {
      selectedButton = buttonName;
      isButtonPressed = true; // Set the flag to true when a button is pressed
    });
  }

  void updateHospitalEnabledStatus(int id, bool enabled, String hospitalName) {
    setState(() {
      hospital = hospital.map((hospitalItem) {
        if (hospitalItem.hospitalId == id) {
          hospitalItem.enabled = enabled;
          hospitalItem.hospitalName = hospitalName;
        }
        return hospitalItem;
      }).toList();
    });
  }

  void navigateToEditHospital(GetHospitalModel clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HospitalDetailsView(
          getHospitalModel: clinic,
          OnHospitalUpdated: (bool enabled, String hospitalName) {
            updateHospitalEnabledStatus(clinic.id, enabled, hospitalName);
          },
        ),
      ),
    );
  }

  void onHospitalDeleted(int id) {
    setState(() {
      hospital = hospital.map((hospitalItem) {
        if (hospitalItem.hospitalId == id) {
          hospitalItem.enabled = false;
        }
        return hospitalItem;
      }).toList();
    });
  }

  Future<void> searchHospitals(String searchType) async {
    if (searchText.isEmpty) {
      // Display a message if the search text is empty
      AwesomeDialog(
        context: context,
        animType: AnimType.topSlide,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'Enter Search Term First',
        btnOkOnPress: () {
          setState(() {
            selectedButton = "";
          });
        },
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
      ).show();
      setState(() {
        showErrorDialog =
            true; // Set flag to true to prevent showing "No admin found" message
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    String url = "http://10.0.2.2:8081/admin/hosbitals/$searchType/$searchText";
    List<GetHospitalSearch> hospitalData;

    switch (searchType) {
      case 'code':
        hospitalData = await SearchHospital(Dio()).showByCode(url);
        break;
      case 'name':
        hospitalData = await SearchHospital(Dio()).showByName(url);
        break;
      case 'email':
        hospitalData = await SearchHospital(Dio()).showByEmail(url);
        break;
      default:
        hospitalData = [];
    }

    setState(() {
      isLoading = false;
      hospital = hospitalData;
    });

    if (hospitalData.isEmpty) {
      print("No Hospital found with this $searchType");
      setState(() {
        showErrorDialog = false; // Reset flag to false if there are no results
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Search Hospital",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: _focusNode.hasFocus ? Colors.blue : Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Search With ...",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        selectButton('Code');
                        await searchHospitals('code');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedButton == 'Code'
                            ? Colors.blue
                            : Colors.white,
                        side: BorderSide(
                          color: selectedButton == 'Code'
                              ? Colors.blue
                              : Color.fromARGB(175, 0, 0, 0),
                        ),
                        foregroundColor: selectedButton == 'Code'
                            ? Colors.white
                            : Color.fromARGB(175, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.numbers,
                            color: selectedButton == 'Code'
                                ? Colors.white
                                : Color.fromARGB(175, 0, 0, 0),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Code',
                            style: TextStyle(
                              color: selectedButton == 'Code'
                                  ? Colors.white
                                  : Color.fromARGB(175, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        selectButton('Name');
                        await searchHospitals('name');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedButton == 'Name'
                            ? Colors.blue
                            : Colors.white,
                        side: BorderSide(
                          color: selectedButton == 'Name'
                              ? Colors.blue
                              : Color.fromARGB(175, 0, 0, 0),
                        ),
                        foregroundColor: selectedButton == 'Name'
                            ? Colors.white
                            : Color.fromARGB(175, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            color: selectedButton == 'Name'
                                ? Colors.white
                                : Color.fromARGB(175, 0, 0, 0),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Name',
                            style: TextStyle(
                              color: selectedButton == 'Name'
                                  ? Colors.white
                                  : Color.fromARGB(175, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        selectButton('Email');
                        await searchHospitals('email');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedButton == 'Email'
                            ? Colors.blue
                            : Colors.white,
                        side: BorderSide(
                          color: selectedButton == 'Email'
                              ? Colors.blue
                              : Color.fromARGB(175, 0, 0, 0),
                        ),
                        foregroundColor: selectedButton == 'Email'
                            ? Colors.white
                            : Color.fromARGB(175, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.email,
                            color: selectedButton == 'Email'
                                ? Colors.white
                                : Color.fromARGB(175, 0, 0, 0),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: selectedButton == 'Email'
                                  ? Colors.white
                                  : Color.fromARGB(175, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: showErrorDialog
                      ? SizedBox() // Don't show any content when dialog is displayed
                      : hospital.isEmpty && isButtonPressed && !isLoading
                          ? Center(
                              child: Text(
                                "No Hospital found with this $selectedButton",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView(
                              children: hospital.map((hospital) {
                                Color containerColor = hospital.enabled
                                    ? kPrimaryColor
                                    : const Color.fromARGB(155, 33, 149, 243);
                                return GestureDetector(
                                  onTap: () async {
                                    String url =
                                        "http://10.0.2.2:8081/admin/hosbitals/id/${hospital.hospitalId}";
                                    List<GetHospitalModel> hospitalData =
                                        await SearchHospital(Dio())
                                            .showHospitalById(url);
                                    print(hospitalData);
                                    if (hospitalData.isNotEmpty) {
                                      navigateToEditHospital(hospitalData[0]);
                                    }
                                  },
                                  child: SearchHospitalContainer(
                                    infoContainer: InfoContainer(
                                      id: hospital.hospitalId,
                                      fullName: hospital.hospitalName,
                                      containerColor: containerColor,
                                      icon: Icon(Icons.delete,
                                          color: kTextColor), // Pass the icon
                                    ),
                                    getHospitalSearch: hospital,
                                    onHospitalDeleted: onHospitalDeleted,
                                  ),
                                );
                              }).toList(),
                            ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
