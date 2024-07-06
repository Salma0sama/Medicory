import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/emergency_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/emergency_widget.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  late Future<UserMedicalInfo> futureEmergencyData;
  bool imagesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages(context);
  }

  Future<void> _loadImages(BuildContext context) async {
    await Future.wait([
      precacheImage(AssetImage("lib/icons/coronavirus (2).png"), context),
      precacheImage(AssetImage("lib/icons/surgery.png"), context),
      precacheImage(AssetImage("lib/icons/ambulance.png"), context),
      precacheImage(AssetImage("lib/icons/public-relation.png"), context),
      precacheImage(AssetImage("lib/icons/first-aid-kit.png"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    futureEmergencyData = fetchEmergencyData();
  }

  Future<UserMedicalInfo> fetchEmergencyData() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.10:8081/code/91B39A22FA1447E9/emergency'));

    if (response.statusCode == 200) {
      return UserMedicalInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load emergency data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Emergency",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
      ),
      body: !imagesLoaded
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<UserMedicalInfo>(
                future: futureEmergencyData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    UserMedicalInfo emergency = snapshot.data!;
                    return CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: EmergencyTextField(
                              label: "Owner Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              controller: TextEditingController(
                                  text: emergency.ownerName),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: EmergencyTextField(
                              label: "Blood Type",
                              prefixIcon: Icon(
                                Icons.bloodtype,
                                color: kPrimaryColor,
                              ),
                              controller: TextEditingController(
                                  text: emergency.bloodType),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: EmergencyTextField(
                              label: "Chronic Diseases",
                              prefixIcon: Image.asset(
                                "lib/icons/coronavirus (2).png",
                                height: 25,
                                color: kPrimaryColor,
                              ),
                              controller: TextEditingController(
                                  text: emergency.chronicDiseases.join(', ')),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: EmergencyTextField(
                              label: "Allergies",
                              prefixIcon: Icon(
                                Icons.warning,
                                color: kPrimaryColor,
                              ),
                              controller: TextEditingController(
                                  text: emergency.allergies.join(', ')),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: EmergencyTextField(
                              label: "Surgeries",
                              prefixIcon: Image.asset(
                                "lib/icons/surgery.png",
                                height: 25,
                                color: kPrimaryColor,
                              ),
                              controller: TextEditingController(
                                  text: emergency.surgeries.join(', ')),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: EmergencyTextField(
                              label: "Medicines",
                              prefixIcon: Image.asset(
                                "lib/icons/first-aid-kit.png",
                                height: 25,
                                color: kPrimaryColor,
                              ),
                              controller: TextEditingController(
                                  text: emergency.medicines.join(', ')),
                            ),
                          ),
                          SliverToBoxAdapter(
                              child: SizedBox(
                            height: 16,
                          )),
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Call',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "lib/icons/ambulance.png",
                                          height: 25,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Ambulance",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .red, // Always blue text color
                                                ),
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: "123"),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                                maxLines: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Call',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "lib/icons/public-relation.png",
                                          height: 25,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                emergency
                                                    .relativePhoneNumbers[0]
                                                    .relation,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .red, // Always blue text color
                                                ),
                                              ),
                                              TextField(
                                                controller: TextEditingController(
                                                    text: emergency
                                                        .relativePhoneNumbers[0]
                                                        .phone),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                                maxLines: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kPrimaryColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Follow Next Tips',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                    child: Row(
                                      children: [
                                        // Image.asset(
                                        //   "lib/icons/public-relation.png",
                                        //   height: 25,
                                        //   color: Colors.red,
                                        // ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "1- Call Emergency Services",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                              Text(
                                                "2- Check Breathing",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                              Text(
                                                "3- Check For Responsiveness",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                              Text(
                                                "4- Provide Information",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                              Text(
                                                "5- Do Not Move Injured Person",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                              Text(
                                                "6- Perform Basic First Aid",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                              Text(
                                                "7- Stay with the Person",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        kPrimaryColor // Always blue text color
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                        ]);
                  }
                },
              ),
            ),
    );
  }
}




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:testtt/models/emergency_model.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:testtt/widgets/emergency_widget.dart';

// class EmergencyScreen extends StatefulWidget {
//   @override
//   _EmergencyScreenState createState() => _EmergencyScreenState();
// }

// class _EmergencyScreenState extends State<EmergencyScreen> {
//   late Future<UserMedicalInfo> futureEmergencyData;
//   bool imagesLoaded = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadImages(context);
//   }

//   Future<void> _loadImages(BuildContext context) async {
//     await Future.wait([
//       precacheImage(AssetImage("lib/icons/coronavirus (2).png"), context),
//       precacheImage(AssetImage("lib/icons/surgery.png"), context),
//       precacheImage(AssetImage("lib/icons/ambulance.png"), context),
//       precacheImage(AssetImage("lib/icons/public-relation.png"), context),
//     ]);
//     setState(() {
//       imagesLoaded = true;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     futureEmergencyData = fetchEmergencyData();
//   }

//   Future<UserMedicalInfo> fetchEmergencyData() async {
//     final response = await http.get(
//         Uri.parse('http://192.168.1.10:8081/code/91B39A22FA1447E9/emergency'));

//     if (response.statusCode == 200) {
//       return UserMedicalInfo.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load emergency data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Emergency",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//       ),
//       body: !imagesLoaded
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: FutureBuilder<UserMedicalInfo>(
//                 future: futureEmergencyData,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData) {
//                     return Center(child: Text('No data available'));
//                   } else {
//                     UserMedicalInfo emergency = snapshot.data!;
//                     return CustomScrollView(
//                         physics: BouncingScrollPhysics(),
//                         slivers: [
//                           SliverToBoxAdapter(
//                             child: EmergencyTextField(
//                               label: "Owner Name",
//                               prefixIcon: Icon(
//                                 Icons.person,
//                                 color: kPrimaryColor,
//                               ),
//                               controller: TextEditingController(
//                                   text: emergency.ownerName),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: EmergencyTextField(
//                               label: "Blood Type",
//                               prefixIcon: Icon(
//                                 Icons.bloodtype,
//                                 color: kPrimaryColor,
//                               ),
//                               controller: TextEditingController(
//                                   text: emergency.bloodType),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: EmergencyTextField(
//                               label: "Chronic Diseases",
//                               prefixIcon: Image.asset(
//                                 "lib/icons/coronavirus (2).png",
//                                 height: 25,
//                                 color: kPrimaryColor,
//                               ),
//                               controller: TextEditingController(
//                                   text: emergency.chronicDiseases.join(', ')),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: EmergencyTextField(
//                               label: "Allergies",
//                               prefixIcon: Icon(
//                                 Icons.warning,
//                                 color: kPrimaryColor,
//                               ),
//                               controller: TextEditingController(
//                                   text: emergency.allergies.join(', ')),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: EmergencyTextField(
//                               label: "Surgeries",
//                               prefixIcon: Image.asset(
//                                 "lib/icons/surgery.png",
//                                 height: 25,
//                                 color: kPrimaryColor,
//                               ),
//                               controller: TextEditingController(
//                                   text: emergency.surgeries.join(', ')),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                               child: SizedBox(
//                             height: 16,
//                           )),
//                           SliverToBoxAdapter(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.red,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(16)),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(16),
//                                           topRight: Radius.circular(16)),
//                                     ),
//                                     padding: EdgeInsets.all(10.0),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'Call',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 12),
//                                     child: Row(
//                                       children: [
//                                         Image.asset(
//                                           "lib/icons/ambulance.png",
//                                           height: 25,
//                                           color: Colors.red,
//                                         ),
//                                         SizedBox(width: 12),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                 "Ambulance",
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors
//                                                       .red, // Always blue text color
//                                                 ),
//                                               ),
//                                               TextField(
//                                                 controller:
//                                                     TextEditingController(
//                                                         text: "123"),
//                                                 decoration: InputDecoration(
//                                                   border: InputBorder.none,
//                                                   isDense: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.black,
//                                                 ),
//                                                 maxLines: null,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: SizedBox(
//                               height: 16,
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.red,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(16)),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(16),
//                                           topRight: Radius.circular(16)),
//                                     ),
//                                     padding: EdgeInsets.all(10.0),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'Call',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 12),
//                                     child: Row(
//                                       children: [
//                                         Image.asset(
//                                           "lib/icons/public-relation.png",
//                                           height: 25,
//                                           color: Colors.red,
//                                         ),
//                                         SizedBox(width: 12),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                 emergency
//                                                     .relativePhoneNumbers[0]
//                                                     .relation,
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors
//                                                       .red, // Always blue text color
//                                                 ),
//                                               ),
//                                               TextField(
//                                                 controller: TextEditingController(
//                                                     text: emergency
//                                                         .relativePhoneNumbers[0]
//                                                         .phone),
//                                                 decoration: InputDecoration(
//                                                   border: InputBorder.none,
//                                                   isDense: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.black,
//                                                 ),
//                                                 maxLines: null,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: SizedBox(
//                               height: 16,
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: kPrimaryColor,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(16)),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: kPrimaryColor,
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(16),
//                                           topRight: Radius.circular(16)),
//                                     ),
//                                     padding: EdgeInsets.all(10.0),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'Follow Next Tips',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 8, vertical: 12),
//                                     child: Row(
//                                       children: [
//                                         // Image.asset(
//                                         //   "lib/icons/public-relation.png",
//                                         //   height: 25,
//                                         //   color: Colors.red,
//                                         // ),
//                                         SizedBox(width: 12),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                 "1- Call Emergency Services",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                               Text(
//                                                 "2- Check Breathing",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                               Text(
//                                                 "3- Check For Responsiveness",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                               Text(
//                                                 "4- Provide Information",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                               Text(
//                                                 "5- Do Not Move Injured Person",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                               Text(
//                                                 "6- Perform Basic First Aid",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                               Text(
//                                                 "7- Stay with the Person",
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         kPrimaryColor // Always blue text color
//                                                     ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: SizedBox(
//                               height: 16,
//                             ),
//                           ),
//                         ]);
//                   }
//                 },
//               ),
//             ),
//     );
//   }
// }