// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:medicory/models/get_admin_model.dart';
// import 'package:medicory/models/search_model.dart';
// import 'package:medicory/services/search_admin_service.dart';
// import 'package:medicory/views/show_admin_view.dart';
// import 'package:medicory/widgets/constants.dart';
// import 'package:medicory/widgets/search_container_widget.dart';
// import 'package:medicory/widgets/search_with_selector_view.dart';

// class SearchAdminView extends StatefulWidget {
//   const SearchAdminView({super.key});

//   @override
//   State<SearchAdminView> createState() => _SearchAdminViewState();
// }

// class _SearchAdminViewState extends State<SearchAdminView> {
//   String? searchWith;
//   String searchText = "";
//   int? adminId;
//   String? adminName;
//   List<GetAdminSearch> admin = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Search admin",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             SearchWithSelector(
//               labelText: "Search With :",
//               options: ["Code", "Name", "E-mail"],
//               selectedValue: searchWith,
//               onChanged: (value) {
//                 setState(() {
//                   searchWith = value;
//                   searchText = ""; // Clear text field for Code search
//                   adminId = null; // Clear previous owner ID
//                   adminName = null; // Clear previous owner full name
//                 });
//               },
//             ),
//             if (searchWith != null) // Only render if search option is selected
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     suffixIcon: Icon(
//                       Icons.search,
//                       color: kPrimaryColor,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: kPrimaryColor,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                         color: kPrimaryColor,
//                       ),
//                     ),
//                     labelText: searchWith == "Code"
//                         ? "Search Code"
//                         : searchWith == "Name"
//                             ? "Search Name"
//                             : searchWith == "E-mail"
//                                 ? "Search E-mail"
//                                 : "Search",
//                     hintText: searchWith == "Code"
//                         ? "Enter Code"
//                         : searchWith == "Name"
//                             ? "Enter name"
//                             : searchWith == "E-mail"
//                                 ? "Enter E-mail"
//                                 : "Please select a search option.",
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       searchText = value;
//                     });
//                   },
//                 ),
//               ),
//             SizedBox(height: 15),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kPrimaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 minimumSize: const Size(120, 40),
//               ),
//               onPressed: () async {
//                 if (searchWith != null) {
//                   if (searchWith == "Code" && searchText.isNotEmpty) {
//                     print("Searching by code $searchText");
//                     String url =
//                         "http://10.0.2.2:8081/admin/admins/code/$searchText";
//                     List<GetAdminSearch> adminData =
//                         await SearchAdmin(Dio()).showByCode(url);
//                     if (adminData.isNotEmpty) {
//                       setState(() {
//                         admin = adminData;
//                       });
//                     } else {
//                       print("No admin found with this code");
//                     }
//                   } else if (searchWith == "Name" && searchText.isNotEmpty) {
//                     print("Searching by name $searchText");
//                     String url =
//                         "http://10.0.2.2:8081/admin/admins/name/$searchText";
//                     List<GetAdminSearch> adminData =
//                         await SearchAdmin(Dio()).showByName(url);
//                     setState(() {
//                       admin = adminData;
//                     });
//                   } else if (searchWith == "E-mail" && searchText.isNotEmpty) {
//                     print("Searching by email $searchText");
//                     String url =
//                         "http://10.0.2.2:8081/admin/admins/email/$searchText";
//                     List<GetAdminSearch> adminData =
//                         await SearchAdmin(Dio()).showByEmail(url);
//                     if (adminData.isNotEmpty) {
//                       setState(() {
//                         admin = adminData;
//                       });
//                     } else {
//                       print("No admin found with this email");
//                     }
//                   } else {
//                     print("Please enter a valid search term.");
//                   }
//                 } else {
//                   print("Please select a search option.");
//                 }
//               },
//               child: Text(
//                 "Search",
//                 style: TextStyle(
//                   fontSize: 19,
//                   color: kTextColor,
//                 ),
//               ),
//             ),
//             SizedBox(height: 15),
//             Column(
//               children: admin.map((admin) {
//                 Color containerColor = admin.enabled
//                     ? kPrimaryColor
//                     : const Color.fromARGB(155, 33, 149, 243);
//                 return GestureDetector(
//                   onTap: () async {
//                     String url = "http://10.0.2.2:8081/admin/admins/id/1/admin";
//                     List<GetAdminModel> adminData =
//                         await SearchAdmin(Dio()).showAdminById(url);
//                     print(adminData);
//                     if (adminData.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ShowAdminView(
//                                   getAdminModel: adminData[0],
//                                 )),
//                       );
//                     }
//                   },
//                   child: SearchContainer(
//                     id: admin.id,
//                     fullName: admin.adminName,
//                     containerColor: containerColor,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_admin_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_admin_service.dart';
import 'package:medicory/views/show_admin_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_container_widget.dart';
import 'package:medicory/widgets/search_with_selector_view.dart';

class SearchAdminView extends StatefulWidget {
  const SearchAdminView({super.key});

  @override
  State<SearchAdminView> createState() => _SearchAdminViewState();
}

class _SearchAdminViewState extends State<SearchAdminView> {
  String? searchWith;
  String searchText = "";
  int? adminId;
  String? adminName;
  List<GetAdminSearch> admin = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Search admin",
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
                  adminId = null; // Clear previous owner ID
                  adminName = null; // Clear previous owner full name
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
                        "http://10.0.2.2:8081/admin/admins/code/$searchText";
                    List<GetAdminSearch> adminData =
                        await SearchAdmin(Dio()).showByCode(url);
                    if (adminData.isNotEmpty) {
                      setState(() {
                        admin = adminData;
                      });
                    } else {
                      setState(() {
                        admin = []; // Clear admin list if no results
                      });
                      print("No admin found with this code");
                    }
                  } else if (searchWith == "Name" && searchText.isNotEmpty) {
                    print("Searching by name $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/admins/name/$searchText";
                    List<GetAdminSearch> adminData =
                        await SearchAdmin(Dio()).showByName(url);
                    setState(() {
                      admin = adminData;
                    });
                  } else if (searchWith == "E-mail" && searchText.isNotEmpty) {
                    print("Searching by email $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/admins/email/$searchText";
                    List<GetAdminSearch> adminData =
                        await SearchAdmin(Dio()).showByEmail(url);
                    if (adminData.isNotEmpty) {
                      setState(() {
                        admin = adminData;
                      });
                    } else {
                      setState(() {
                        admin = []; // Clear admin list if no results
                      });
                      print("No admin found with this email");
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
              children: admin.map((admin) {
                Color containerColor = admin.enabled
                    ? kPrimaryColor
                    : const Color.fromARGB(155, 33, 149, 243);
                return GestureDetector(
                  onTap: () async {
                    String url =
                        "http://10.0.2.2:8081/admin/admins/id/${admin.id}/admin";
                    List<GetAdminModel> adminData =
                        await SearchAdmin(Dio()).showAdminById(url);
                    print(adminData);
                    if (adminData.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowAdminView(
                                  getAdminModel: adminData[0],
                                )),
                      );
                    }
                  },
                  child: SearchContainer(
                    id: admin.id,
                    fullName: admin.adminName,
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
