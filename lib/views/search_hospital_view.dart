import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_hospital_service.dart';
import 'package:medicory/views/show_hospital_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_container_widget.dart';
import 'package:medicory/widgets/search_with_selector_view.dart';

class SearchHospitalView extends StatefulWidget {
  const SearchHospitalView({super.key});

  @override
  State<SearchHospitalView> createState() => _SearchHospitalViewState();
}

class _SearchHospitalViewState extends State<SearchHospitalView> {
  String? searchWith;
  String searchText = "";
  int? hospitalId;
  String? hospitalName;
  List<GetHospitalSearch> hospital = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Search hospital",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SearchWithSelector(
              labelText: "Search With :",
              options: ["Code", "Name", "E-mail"],
              selectedValue: searchWith,
              onChanged: (value) {
                setState(() {
                  searchWith = value;
                  searchText = ""; // Clear text field for Code search
                  hospitalId = null; // Clear previous owner ID
                  hospitalName = null; // Clear previous owner full name
                });
              },
            ),
            if (searchWith != null) // Only render if search option is selected
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    labelText: searchWith == "Code"
                        ? "Search Code"
                        : searchWith == "Name"
                            ? "Search Name"
                            : searchWith == "E-mail"
                                ? "Search E-mail"
                                : "Search",
                    hintText: searchWith == "Code"
                        ? "Enter Code"
                        : searchWith == "Name"
                            ? "Enter name"
                            : searchWith == "E-mail"
                                ? "Enter E-mail"
                                : "Please select a search option.",
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(120, 40),
              ),
              onPressed: () async {
                if (searchWith != null) {
                  if (searchWith == "Code" && searchText.isNotEmpty) {
                    print("Searching by code $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/hosbitals/code/$searchText";
                    List<GetHospitalSearch> hospitalData =
                        await SearchHospital(Dio()).showByCode(url);
                    if (hospitalData.isNotEmpty) {
                      setState(() {
                        hospital = hospitalData;
                      });
                    } else {
                      print("No hospital found with this code");
                    }
                  } else if (searchWith == "Name" && searchText.isNotEmpty) {
                    print("Searching by name $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/hosbitals/name/$searchText";
                    List<GetHospitalSearch> hospitalData =
                        await SearchHospital(Dio()).showByName(url);
                    setState(() {
                      hospital = hospitalData;
                    });
                  } else if (searchWith == "E-mail" && searchText.isNotEmpty) {
                    print("Searching by email $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/hosbitals/email/$searchText";
                    List<GetHospitalSearch> hospitalData =
                        await SearchHospital(Dio()).showByEmail(url);
                    if (hospitalData.isNotEmpty) {
                      setState(() {
                        hospital = hospitalData;
                      });
                    } else {
                      print("No hospital found with this email");
                    }
                  } else {
                    print("Please enter a valid search term.");
                  }
                } else {
                  print("Please select a search option.");
                }
              },
              child: Text(
                "Search",
                style: TextStyle(
                  fontSize: 19,
                  color: kTextColor,
                ),
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: hospital.map((hospital) {
                Color containerColor = hospital.enabled
                    ? kPrimaryColor
                    : const Color.fromARGB(155, 33, 149, 243);
                return GestureDetector(
                  onTap: () async {
                    String url =
                        "http://10.0.2.2:8081/admin/hosbitals/id/${hospital.hospitalId}";
                    List<GetHospitalModel> hospitalData =
                        await SearchHospital(Dio()).showHospitalById(url);
                    print(hospitalData);
                    if (hospitalData.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowHospitalView(
                                  getHospitalModel: hospitalData[0],
                                )),
                      );
                    }
                  },
                  child: SearchContainer(
                    id: hospital.hospitalId,
                    fullName: hospital.hospitalName,
                    containerColor: containerColor,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
