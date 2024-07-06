import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/get_owner_model.dart';

class EditOwnerService {
  Future<bool> EditOwner({
    required int id,
    required String firstName,
    required String middleName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String address,
    required String bloodType,
    required int nationalId,
    required String maritalStatus,
    required String job,
    required List<RelativePhoneNumber> relativePhoneNumbers,
    required UserDetail user,
  }) async {
    final Map<String, dynamic> ownerData = {
      "id": id,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "address": address,
      "bloodType": bloodType,
      "nationalId": nationalId,
      "maritalStatus": maritalStatus,
      "job": job,
      "relativePhoneNumbers":
          relativePhoneNumbers.map((r) => r.toJson()).toList(),
      "user": user.toJson(),
    };

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8081/admin/owners/owner/id/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ownerData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to edit owner ${response.statusCode} with ${response.body}");
    }
  }
}
