import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewHospitalService {
  Future<bool> addNewHospital({
    required String name,
    required String googleMapsLink,
    required String address,
    required String email,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> hospitalData = {
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "email": email,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/hosbitals/hospital"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(hospitalData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          "Failed to add Hospital ${response.statusCode} and body: ${response.body}");
    }
  }
}
