import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/get_pharmacy_model.dart';

class EditPharmacyService {
  Future<GetPharmacyModel> EditPharmacy({
    required int id,
    required String name,
    required String googleMapsLink,
    required String address,
    required String ownerName,
    required String code,
    required String email,
    required String password,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> pharmacyData = {
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
      Uri.parse("http://10.0.2.2:8081/admin/pharmacies/id/$id/pharmacy"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pharmacyData),
    );

    if (response.statusCode == 201) {
      return GetPharmacyModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to edit pharmacy ${response.statusCode} with ${response.body}");
    }
  }
}
