import 'dart:convert';
import 'package:http/http.dart' as http;

class EditAdminService {
  Future<bool> EditAdmin({
    required int id,
    required String firstName,
    required String lastName,
    required String maritalStatus,
    required String gender,
    required String code,
    required String email,
    required String? password,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> adminData = {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "maritalStatus": maritalStatus,
      "gender": gender,
      "code": code,
      "email": email,
      "password": password,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8081/admin/admins/id/$id/admin"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(adminData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to edit admin ${response.statusCode} with ${response.body}");
    }
  }
}
