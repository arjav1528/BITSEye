import 'package:newproject2/constants.dart';

import 'package:http/http.dart' as http;

class Fetch {
  Future<String> fetchStudents() async {
    try {
      var response = await http.get(Uri.parse(everyone));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw '${response.statusCode}';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchHostels() async {
    try {
      var response2 = await http.get(Uri.parse(hosteldata));
      if (response2.statusCode == 200) {
        return response2.body;
      } else {
        throw '${response2.statusCode}';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
