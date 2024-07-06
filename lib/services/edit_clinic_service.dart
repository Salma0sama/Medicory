import 'dart:convert';
import 'package:http/http.dart' as http;

class EditClinicService {
  Future<bool> EditClinic({
    required int id,
    required String name,
    required String googleMapsLink,
    required String address,
    required String ownerName,
    required String specialization,
    required String code,
    required String email,
    required String? password,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> clinicData = {
      "id": id,
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "ownerName": ownerName,
      "specialization": specialization,
      "code": code,
      "email": email,
      "password": password,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8081/admin/clinics/id/$id/clinic"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(clinicData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to edit clinic ${response.statusCode} with ${response.body}");
    }
  }
}
