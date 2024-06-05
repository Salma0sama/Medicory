import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/get_hospital_model.dart';

class EditHospitalService {
  Future<GetHospitalModel> EditHospital({
    required int id,
    required String name,
    required String googleMapsLink,
    required String address,
    required String code,
    required String email,
    required String password,
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

    if (response.statusCode == 201) {
      return GetHospitalModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to edit hospital ${response.statusCode} with ${response.body}");
    }
  }
}