
  import 'package:newproject2/models/student.dart';
class Search{
  bool namesearch(String query, Student student) {
    List<String> keywords = query.split(' ');
    bool matchall = true;
    for (String keyword in keywords) {
      if (!student.name.toLowerCase().contains(keyword.toLowerCase())) {
        matchall = false;
        break;
      } else {
        matchall = true;
      }
    }
    return matchall;
  }
  


}