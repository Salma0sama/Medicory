// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/models/get_owner_model.dart';
// import 'package:testtt/models/search_model.dart';
// import 'package:testtt/services/search_owner_service.dart';
// import 'package:testtt/views/owner_details_view.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'package:testtt/widgets/search_owner_container_widget.dart';

// class SearchOwnerView extends StatefulWidget {
//   const SearchOwnerView({Key? key}) : super(key: key);

//   @override
//   _SearchOwnerViewState createState() => _SearchOwnerViewState();
// }

// class _SearchOwnerViewState extends State<SearchOwnerView> {
//   String searchText = "";
//   String? searchWith;
//   List<GetOwnerSearch> owner = [];
//   FocusNode _focusNode = FocusNode();
//   String selectedButton = "";
//   bool isLoading = false;
//   bool isButtonPressed = false;
//   bool showErrorDialog = false;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void selectButton(String buttonName) {
//     setState(() {
//       selectedButton = buttonName;
//       isButtonPressed = true; // Set the flag to true when a button is pressed
//     });
//   }

//   void updateOwnerEnabledStatus(int id, bool enabled, String firstName,
//       String middleName, String lastName) {
//     setState(() {
//       owner = owner.map((ownerItem) {
//         if (ownerItem.id == id) {
//           ownerItem.isEnabled = enabled;
//           ownerItem.fullName = firstName + " " + middleName + " " + lastName;
//         }
//         return ownerItem;
//       }).toList();
//     });
//   }

//   void navigateToOwnerDetails(
//       GetOwnerModel owner,
//       RelativePhoneNumber relativePhoneNumber,
//       UserDetail userDetail,
//       UserPhoneNumber userPhoneNumber) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ownerDetailsView(
//           getOwnerModel: owner,
//           OnOwnerUpdated: (bool enabled, String firstName, String middleName,
//               String lastName) {
//             updateOwnerEnabledStatus(
//                 owner.id, enabled, firstName, middleName, lastName);
//           },
//           relativePhoneNumber: relativePhoneNumber,
//           userDetail: userDetail,
//           userPhoneNumber: userPhoneNumber,
//         ),
//       ),
//     );
//   }

//   void onOwnerDeleted(int id) {
//     setState(() {
//       owner = owner.map((ownerItem) {
//         if (ownerItem.id == id) {
//           ownerItem.isEnabled = false;
//         }
//         return ownerItem;
//       }).toList();
//     });
//   }

//   Future<void> searchOwners(String searchType) async {
//     if (searchText.isEmpty) {
//       // Display a message if the search text is empty
//       AwesomeDialog(
//         context: context,
//         animType: AnimType.topSlide,
//         dialogType: DialogType.error,
//         title: 'Error',
//         desc: 'Enter Search Term First',
//         btnOkOnPress: () {
//           setState(() {
//             selectedButton = "";
//           });
//         },
//         dismissOnTouchOutside: false,
//         dismissOnBackKeyPress: false,
//       ).show();
//       setState(() {
//         showErrorDialog =
//             true; // Set flag to true to prevent showing "No admin found" message
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });
//     String url = "http://10.0.2.2:8081/admin/owners/$searchType/$searchText";
//     List<GetOwnerSearch> ownerData;

//     switch (searchType) {
//       case 'code':
//         ownerData = await SearchOwner(Dio()).showByCode(url);
//         break;
//       case 'name':
//         ownerData = await SearchOwner(Dio()).showByName(url);
//         break;
//       case 'email':
//         ownerData = await SearchOwner(Dio()).showByEmail(url);
//         break;
//       default:
//         ownerData = [];
//     }

//     setState(() {
//       isLoading = false;
//       owner = ownerData;
//     });

//     if (ownerData.isEmpty) {
//       print("No Owner found with this $searchType");
//       setState(() {
//         showErrorDialog = false; // Reset flag to false if there are no results
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Search Owner",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: TextField(
//                     focusNode: _focusNode,
//                     decoration: InputDecoration(
//                       hintText: "Search",
//                       prefixIcon: Icon(
//                         Icons.search,
//                         color: _focusNode.hasFocus ? Colors.blue : Colors.black,
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(
//                           color: Colors.blue,
//                         ),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         vertical: 10,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         searchText = value;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Text(
//                   "Search With ...",
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 17,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () async {
//                         selectButton('Code');
//                         await searchOwners('code');
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: selectedButton == 'Code'
//                             ? Colors.blue
//                             : Colors.white,
//                         side: BorderSide(
//                           color: selectedButton == 'Code'
//                               ? Colors.blue
//                               : Color.fromARGB(175, 0, 0, 0),
//                         ),
//                         foregroundColor: selectedButton == 'Code'
//                             ? Colors.white
//                             : Color.fromARGB(175, 0, 0, 0),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.numbers,
//                             color: selectedButton == 'Code'
//                                 ? Colors.white
//                                 : Color.fromARGB(175, 0, 0, 0),
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Code',
//                             style: TextStyle(
//                               color: selectedButton == 'Code'
//                                   ? Colors.white
//                                   : Color.fromARGB(175, 0, 0, 0),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     OutlinedButton(
//                       onPressed: () async {
//                         selectButton('Name');
//                         await searchOwners('name');
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: selectedButton == 'Name'
//                             ? Colors.blue
//                             : Colors.white,
//                         side: BorderSide(
//                           color: selectedButton == 'Name'
//                               ? Colors.blue
//                               : Color.fromARGB(175, 0, 0, 0),
//                         ),
//                         foregroundColor: selectedButton == 'Name'
//                             ? Colors.white
//                             : Color.fromARGB(175, 0, 0, 0),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.person,
//                             color: selectedButton == 'Name'
//                                 ? Colors.white
//                                 : Color.fromARGB(175, 0, 0, 0),
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Name',
//                             style: TextStyle(
//                               color: selectedButton == 'Name'
//                                   ? Colors.white
//                                   : Color.fromARGB(175, 0, 0, 0),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     OutlinedButton(
//                       onPressed: () async {
//                         selectButton('Email');
//                         await searchOwners('email');
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: selectedButton == 'Email'
//                             ? Colors.blue
//                             : Colors.white,
//                         side: BorderSide(
//                           color: selectedButton == 'Email'
//                               ? Colors.blue
//                               : Color.fromARGB(175, 0, 0, 0),
//                         ),
//                         foregroundColor: selectedButton == 'Email'
//                             ? Colors.white
//                             : Color.fromARGB(175, 0, 0, 0),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.email,
//                             color: selectedButton == 'Email'
//                                 ? Colors.white
//                                 : Color.fromARGB(175, 0, 0, 0),
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Email',
//                             style: TextStyle(
//                               color: selectedButton == 'Email'
//                                   ? Colors.white
//                                   : Color.fromARGB(175, 0, 0, 0),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 Expanded(
//                   child: showErrorDialog
//                       ? SizedBox() // Don't show any content when dialog is displayed
//                       : owner.isEmpty && isButtonPressed && !isLoading
//                           ? Center(
//                               child: Text(
//                                 "No Owner found with this $selectedButton",
//                                 style: TextStyle(
//                                     color: Colors.black54,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             )
//                           : ListView(
//                               children: owner.map((owner) {
//                                 Color containerColor = owner.isEnabled
//                                     ? kPrimaryColor
//                                     : const Color.fromARGB(155, 33, 149, 243);
//                                 return GestureDetector(
//                                   onTap: () async {
//                                     String url =
//                                         "http://10.0.2.2:8081/admin/owners/id/${owner.id}";
//                                     List<GetOwnerModel> ownerData =
//                                         await SearchOwner(Dio())
//                                             .showOwnerById(url);
//                                     print(ownerData);
//                                     if (ownerData.isNotEmpty) {
//                                       navigateToOwnerDetails(ownerData[0]);
//                                     }
//                                   },
//                                   child: SearchOwnerContainer(
//                                     infoContainer: InfoContainer(
//                                       id: owner.id,
//                                       fullName: owner.fullName,
//                                       containerColor: containerColor,
//                                       icon: Icon(Icons.delete,
//                                           color: kTextColor), // Pass the icon
//                                     ),
//                                     getOwnerSearch: owner,
//                                     onOwnerDeleted: onOwnerDeleted,
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                 ),
//               ],
//             ),
//           ),
//           if (isLoading)
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_owner_service.dart';
import 'package:medicory/views/owner_details_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_owner_container_widget.dart';

class SearchOwnerView extends StatefulWidget {
  const SearchOwnerView({Key? key}) : super(key: key);

  @override
  _SearchOwnerViewState createState() => _SearchOwnerViewState();
}

class _SearchOwnerViewState extends State<SearchOwnerView> {
  String searchText = "";
  String? searchWith;
  List<GetOwnerSearch> owner = [];
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

  void updateOwnerEnabledStatus(int id, bool enabled, String firstName,
      String middleName, String lastName) {
    setState(() {
      owner = owner.map((ownerItem) {
        if (ownerItem.id == id) {
          ownerItem.isEnabled = enabled;
          ownerItem.fullName = firstName + " " + middleName + " " + lastName;
        }
        return ownerItem;
      }).toList();
    });
  }

  void navigateToOwnerDetails(
    GetOwnerModel owner,
    List<RelativePhoneNumber> relativePhoneNumbers,
    UserDetail userDetail,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ownerDetailsView(
          getOwnerModel: owner,
          OnOwnerUpdated: (bool enabled, String firstName, String middleName,
              String lastName) {
            updateOwnerEnabledStatus(
                owner.id, enabled, firstName, middleName, lastName);
          },
          relativePhoneNumber: relativePhoneNumbers,
          userDetail: userDetail,
        ),
      ),
    );
  }

  void onOwnerDeleted(int id) {
    setState(() {
      owner = owner.map((ownerItem) {
        if (ownerItem.id == id) {
          ownerItem.isEnabled = false;
        }
        return ownerItem;
      }).toList();
    });
  }

  Future<void> searchOwners(String searchType) async {
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
    String url = "http://10.0.2.2:8081/admin/owners/$searchType/$searchText";
    List<GetOwnerSearch> ownerData;

    switch (searchType) {
      case 'code':
        ownerData = await SearchOwner(Dio()).showByCode(url);
        break;
      case 'name':
        ownerData = await SearchOwner(Dio()).showByName(url);
        break;
      case 'email':
        ownerData = await SearchOwner(Dio()).showByEmail(url);
        break;
      default:
        ownerData = [];
    }

    setState(() {
      isLoading = false;
      owner = ownerData;
    });

    if (ownerData.isEmpty) {
      print("No Owner found with this $searchType");
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
          "Search Owner",
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
                        await searchOwners('code');
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
                        await searchOwners('name');
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
                        await searchOwners('email');
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
                      : owner.isEmpty && isButtonPressed && !isLoading
                          ? Center(
                              child: Text(
                                "No Owner found with this $selectedButton",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView(
                              children: owner.map((owner) {
                                Color containerColor = owner.isEnabled
                                    ? kPrimaryColor
                                    : const Color.fromARGB(155, 33, 149, 243);
                                return GestureDetector(
                                  onTap: () async {
                                    String url =
                                        "http://10.0.2.2:8081/admin/owners/id/${owner.id}";
                                    List<GetOwnerModel> ownerData =
                                        await SearchOwner(Dio())
                                            .showOwnerById(url);
                                    print(ownerData);
                                    if (ownerData.isNotEmpty) {
                                      navigateToOwnerDetails(
                                        ownerData[0],
                                        ownerData[0].relativePhoneNumbers,
                                        ownerData[0].user,
                                      );
                                    }
                                  },
                                  child: SearchOwnerContainer(
                                    infoContainer: InfoContainer(
                                      id: owner.id,
                                      fullName: owner.fullName,
                                      containerColor: containerColor,
                                      icon: Icon(Icons.delete,
                                          color: kTextColor), // Pass the icon
                                    ),
                                    getOwnerSearch: owner,
                                    onOwnerDeleted: onOwnerDeleted,
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
