import 'dart:convert';
import 'package:http/http.dart' as http;

class EditLabService {
  Future<bool> EditLab({
    required int id,
    required String name,
    required String googleMapsLink,
    required String address,
    required String ownerName,
    required String code,
    required String email,
    required String? password,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> labData = {
      "id": id,
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "ownerName": ownerName,
      "code": code,
      "email": email,
      "password": password,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8081/admin/labs/lab/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(labData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to edit lab ${response.statusCode} with ${response.body}");
    }
  }
}
