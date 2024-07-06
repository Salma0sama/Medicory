// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class NFCDataStorageScreen extends StatefulWidget {
// //   @override
// //   _NFCDataStorageScreenState createState() => _NFCDataStorageScreenState();
// // }

// // class _NFCDataStorageScreenState extends State<NFCDataStorageScreen> {
// //   SharedPreferences? _prefs;
// //   String _storedData = '1CDAA42EA626493F';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initPrefs();
// //   }

// //   Future<void> _initPrefs() async {
// //     _prefs = await SharedPreferences.getInstance();
// //   }

// //   Future<void> _storeData(String data) async {
// //     setState(() {
// //       _storedData = data;
// //     });
// //     await _prefs?.setString('nfcData', data);
// //   }

// //   Future<String?> _retrieveStoredData() async {
// //     return _prefs?.getString('nfcData');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('NFC Data Storage'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text('Stored NFC Data:'),
// //             Text(_storedData),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 // Simulate NFC scanning result
// //                 String scannedData =
// //                     'Data from NFC'; // Replace with actual NFC scanning logic
// //                 await _storeData(scannedData);
// //               },
// //               child: Text('Simulate NFC Scan'),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 String? retrievedData = await _retrieveStoredData();
// //                 if (retrievedData != null) {
// //                   setState(() {
// //                     _storedData = retrievedData;
// //                   });
// //                 }
// //               },
// //               child: Text('Retrieve Stored Data'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

// class WriteNfcScreen extends StatefulWidget {
//   @override
//   _WriteNfcScreenState createState() => _WriteNfcScreenState();
// }

// class _WriteNfcScreenState extends State<WriteNfcScreen> {
//   String _message = "Scan an NFC tag to write data";

//   Future<void> _writeNfc(String data) async {
//     try {
//       var tag = await FlutterNfcKit.poll();
//       if (tag != null) {
//         // Write NDEF message
//         await FlutterNfcKit.transceive(
//             "00A4000C02D276"); // Select NDEF tag application
//         await FlutterNfcKit.transceive(
//             "00D6000007D1010B54026869"); // Write NDEF record

//         // Update the message
//         setState(() {
//           _message = "Data written to NFC tag successfully";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _message = "Error writing to NFC tag: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Write to NFC'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(_message),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _writeNfc("Your data here");
//               },
//               child: Text('Write to NFC'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
