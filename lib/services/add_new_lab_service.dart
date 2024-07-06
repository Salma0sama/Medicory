import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewLabService {
  Future<bool> addNewLab({
    required String name,
    required String googleMapsLink,
    required String address,
    required String ownerName,
    required String email,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> labData = {
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "ownerName": ownerName,
      "email": email,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/labs/lab"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(labData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          "Failed to add lab ${response.statusCode} and body: ${response.body}");
    }
  }
}
