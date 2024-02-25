class Student {
  String campusId;
  String name;
  double cgpa;
  String show;
  String? hostel;
  String? room;

  Student({
    required this.campusId,
    required this.name,
    required this.cgpa,
    required this.show,
    this.hostel,
    this.room,
  });

  factory Student.fromJson(String campusId, Map<String, dynamic> json) {
    return Student(
      campusId: campusId,
      name: json['name'],
      cgpa: json['cgpa'].toDouble(),
      show: json['show'].toString(),
    );
  }
  void updateHostelRoom(String hostel, String room) {
    this.hostel = hostel;
    this.room = room;
  }

 


}

