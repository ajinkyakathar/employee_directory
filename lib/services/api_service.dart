import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:employee_directory/models/employee.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/users?limit=100';

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load employees (${response.statusCode})');
    }

    final data = jsonDecode(response.body);
    final List usersJson = data['users'];

    return usersJson.map((json) => Employee.fromJson(json)).toList();
  }
}