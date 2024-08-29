import 'dart:convert';
import 'package:e_invoice/core/values/api_constants.dart';
import 'package:e_invoice/features/home/data/company_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ApiService {
  Future<http.Response> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');

    final body = jsonEncode({
      'password': password,
      'userName': email,
    });
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
    );
    print(response.statusCode);
    print(response.request);
    return response;
  }

  Future<List<GetCompany>> getDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    String? companyCode = prefs.getString('companyCode');
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getDashboardInfo}?CompanyCode=$companyCode&Year=2024-08');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    print(response.request);
    if (response.statusCode == 200) {
      print(response.body);
      return getCompanyFromJson(response.body);
    } else {
      // Handle errors here, possibly throwing an exception or returning an empty list
      throw Exception('Failed to load data');
    }
  }
}

String getFormattedDate() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM');
  String formattedDate = formatter.format(now);
  return formattedDate;
}
