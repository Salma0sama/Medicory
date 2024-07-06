import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_doctor_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_doctor_service.dart';
import 'package:medicory/views/doctor_details_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_doctor_container_widget.dart';

class SearchDoctorView extends StatefulWidget {
  const SearchDoctorView({Key? key}) : super(key: key);

  @override
  _SearchDoctorViewState createState() => _SearchDoctorViewState();
}

class _SearchDoctorViewState extends State<SearchDoctorView> {
  String searchText = "";
  String? searchWith;
  List<GetDoctorSearch> doctor = [];
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

  void updateDoctorEnabledStatus(int id, bool enabled, String firstName,
      String middleName, String lastName) {
    setState(() {
      doctor = doctor.map((doctorItem) {
        if (doctorItem.doctorId == id) {
          doctorItem.enabled = enabled;
          doctorItem.doctorName = firstName + " " + middleName + " " + lastName;
        }
        return doctorItem;
      }).toList();
    });
  }

  void navigateToDoctorDetails(GetDoctorModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => doctorDetailsView(
          getDoctorModel: doctor,
          OnDoctorUpdated: (bool enabled, String firstName, String middleName,
              String lastName) {
            updateDoctorEnabledStatus(
                doctor.id, enabled, firstName, middleName, lastName);
          },
        ),
      ),
    );
  }

  void onDoctorDeleted(int id) {
    setState(() {
      doctor = doctor.map((doctorItem) {
        if (doctorItem.doctorId == id) {
          doctorItem.enabled = false;
        }
        return doctorItem;
      }).toList();
    });
  }

  Future<void> searchDoctors(String searchType) async {
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
    String url = "http://10.0.2.2:8081/admin/doctors/$searchType/$searchText";
    List<GetDoctorSearch> doctorData;

    switch (searchType) {
      case 'code':
        doctorData = await SearchDoctor(Dio()).showByCode(url);
        break;
      case 'name':
        doctorData = await SearchDoctor(Dio()).showByName(url);
        break;
      case 'email':
        doctorData = await SearchDoctor(Dio()).showByEmail(url);
        break;
      default:
        doctorData = [];
    }

    setState(() {
      isLoading = false;
      doctor = doctorData;
    });

    if (doctorData.isEmpty) {
      print("No Doctor found with this $searchType");
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
          "Search Doctor",
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
                        await searchDoctors('code');
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
                        await searchDoctors('name');
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
                        await searchDoctors('email');
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
                      : doctor.isEmpty && isButtonPressed && !isLoading
                          ? Center(
                              child: Text(
                                "No Doctor found with this $selectedButton",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView(
                              children: doctor.map((doctor) {
                                Color containerColor = doctor.enabled
                                    ? kPrimaryColor
                                    : const Color.fromARGB(155, 33, 149, 243);
                                return GestureDetector(
                                  onTap: () async {
                                    String url =
                                        "http://10.0.2.2:8081/admin/doctors/id/${doctor.doctorId}/doctor";
                                    List<GetDoctorModel> doctorData =
                                        await SearchDoctor(Dio())
                                            .showDoctorById(url);
                                    print(doctorData);
                                    if (doctorData.isNotEmpty) {
                                      navigateToDoctorDetails(doctorData[0]);
                                    }
                                  },
                                  child: SearchDoctorContainer(
                                    infoContainer: InfoContainer(
                                      id: doctor.doctorId,
                                      fullName: doctor.doctorName,
                                      containerColor: containerColor,
                                      icon: Icon(Icons.delete,
                                          color: kTextColor), // Pass the icon
                                    ),
                                    getDoctorSearch: doctor,
                                    onDoctorDeleted: onDoctorDeleted,
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
