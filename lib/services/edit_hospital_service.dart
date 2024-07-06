import 'dart:convert';
import 'package:http/http.dart' as http;

class EditHospitalService {
  Future<bool> EditHospital({
    required int id,
    required String name,
    required String googleMapsLink,
    required String address,
    required String code,
    required String email,
    required String? password,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> HospitalData = {
      "id": id,
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "code": code,
      "email": email,
      "password": password,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8081/admin/hosbitals/id/$id/hospital"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(HospitalData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to edit hospital ${response.statusCode} with ${response.body}");
    }
  }
}
