import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cinemaepulmobile/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> fetchData(String route) async {
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";

  final response = await http.get(Uri.parse('$endpoint/$route'),
      headers: {"Authorization": "Bearer $token"});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load details');
  }
}

Future<dynamic> deleteData(String route, dynamic id) async {
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  final response = await http.get(Uri.parse('$endpoint/$route/delete/$id'),
      headers: {"Authorization": "Bearer $token"});
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to load details');
  }
}

Future<bool> createData(String route, dynamic object) async {
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  final response = await http.put(Uri.parse('$endpoint/$route/update/'),
      body: jsonEncode(object.toJson()),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json;charset=utf-8"
      });
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to load details');
  }
}

Future<String?> fetchToken(String username, String motdepasse) async {
  final prefs = await SharedPreferences.getInstance();

  var token = "";
  final responseToken =
      await http.post(Uri.parse("$endpoint/authentification/login"),
          body: jsonEncode({
            "nomUtil": username,
            "motPasse": motdepasse,
          }),
          headers: {"Content-Type": "application/json;charset=utf-8"});

  if (responseToken.statusCode == 200) {
    token = jsonDecode(responseToken.body)["token"];
    prefs.setString('token', token);
    return token;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return null;
  }
}
