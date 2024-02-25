import 'package:newproject2/constants.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Hide{
   Future<http.Response> putrequest(String id) async {
    print(id);
    final response = await http.put(Uri.parse(hide),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "campus_id": id,
        }));

    return response;
  }
}