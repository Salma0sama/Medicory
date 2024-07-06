// import 'package:flutter/material.dart';
// import 'package:testtt/views/emergency_view.dart';
// import 'package:uni_links/uni_links.dart';
// import 'dart:async';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   StreamSubscription? _sub;

//   @override
//   void initState() {
//     super.initState();
//     _initDeepLink();
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   void _initDeepLink() {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri != null) {
//         _handleDeepLink(uri);
//       }
//     }, onError: (err) {
//       // Handle error
//     });
//   }

//   void _handleDeepLink(Uri uri) {
//     // Handle the deep link and navigate to the emergency screen
//     if (uri.host == 'testtt') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => EmergencyScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Deep Link Example'),
//         ),
//         body: Center(
//           child: Text('Awaiting deep link...'),
//         ),
//       ),
//     );
//   }
// }
