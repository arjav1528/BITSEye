// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:newproject2/constants.dart';
import 'package:newproject2/custom_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  late List<Student> students;
  late List<Student> filteredStudents;

  late TextEditingController searchController;
  Set<int> selectedYearFilters = {};
  Set<String> selectedDegreeFilters = {};
  Set<String> selectedDegreeFilters2 = {};
  @override
  void initState() {
    super.initState();
    students = [];
    fetchData();
    filteredStudents = students;
    searchController = TextEditingController();
  }

  Future<List> fetchData() async {
    var response = await http.get(Uri.parse(everyone));
    var response2 = await http.get(Uri.parse(hosteldata));

    setState(() {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      final Map<String, dynamic> data2 = json.decode(response2.body);

      data.forEach((campusId, studentData) {
        students.add(Student.fromJson(campusId, studentData));
      });
      for (var student in students) {
        if (data2.containsKey(student.campusId)) {
          student.updateHostelRoom(data2[student.campusId]['hostel'],
              data2[student.campusId]['room'] ?? 'NA');
        } else {
          student.updateHostelRoom('', '');
        }
      }
      filteredStudents = students;
    });

    return filteredStudents;
  }

  void search(String query) {
    setState(() {
      filteredStudents = students
          .where((student) =>
              (selectedYearFilters.isEmpty || selectedYearFilters.contains(int.parse(student.campusId.toString().substring(0, 4)))) &&
              (selectedDegreeFilters.isEmpty && selectedDegreeFilters2.isEmpty ||
                  selectedDegreeFilters2.isEmpty &&
                      selectedDegreeFilters.any((code) => student.campusId
                          .toString()
                          .substring(4, 8)
                          .contains(code)) ||
                  selectedDegreeFilters.isEmpty &&
                      selectedDegreeFilters2.any((code) => student.campusId
                          .toString()
                          .substring(4, 8)
                          .contains(code)) ||
                  selectedDegreeFilters2.any((code) => student.campusId.toString().substring(4, 8).contains(code)) &&
                      selectedDegreeFilters.any((code) => student.campusId
                          .toString()
                          .substring(4, 8)
                          .contains(code))) &&
              (namesearch(query, student) ||
                  student.campusId.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

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

  void clear() {
    setState(() {
      searchController.clear();
      selectedYearFilters.clear();
      selectedDegreeFilters.clear();
      selectedDegreeFilters2.clear();
      filteredStudents = students;
    });
  }

  void clearsearch() {
    setState(() {
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalFilteredStudents = filteredStudents.length;

    return Scaffold(
      backgroundColor: CustomTheme.darkScaffoldColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.darkScaffoldColor,
        title: const Text(
          'BPGC EVERYONE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: TextField(
              controller: searchController,
              onChanged: search,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: CustomTheme.darkSecondaryColor,
                    width: 3,
                  ),
                ),
                labelText: 'Search',
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clearsearch,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) => StatefulBuilder(
                                  builder: (context, setState) => AlertDialog(
                                    scrollable: true,
                                    backgroundColor:
                                        CustomTheme.darkPrimaryColorVariant,
                                    title: Text(
                                      'Filters',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ToggleButtons(
                                            borderColor: Colors.white,
                                            selectedColor:
                                                Color(Colors.white.value),
                                            isSelected:
                                                List.generate(6, (index) {
                                              return selectedYearFilters
                                                  .contains([
                                                2023,
                                                2022,
                                                2021,
                                                2020,
                                                2019,
                                                2018
                                              ][index]);
                                            }),
                                            onPressed: (index) => setState(() {
                                              final year = [
                                                2023,
                                                2022,
                                                2021,
                                                2020,
                                                2019,
                                                2018
                                              ][index];
                                              if (selectedYearFilters
                                                  .contains(year)) {
                                                selectedYearFilters
                                                    .remove(year);
                                              } else {
                                                selectedYearFilters.add(year);
                                              }
                                              applyFilters();
                                              clearsearch();
                                            }),
                                            fillColor:
                                                CustomTheme.darkSecondaryColor,
                                            children: [
                                              Text(
                                                '2023',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '2022',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '2021',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '2020',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '2019',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '2018',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ToggleButtons(
                                            borderColor: Colors.white,
                                            isSelected: List.generate(
                                                6,
                                                (index) => selectedDegreeFilters
                                                        .contains([
                                                      'A1',
                                                      'A3',
                                                      'A4',
                                                      'A7',
                                                      'A8',
                                                      'AA',
                                                    ][index])),
                                            onPressed: (index) => setState(() {
                                              final degreeCodes = [
                                                'A1',
                                                'A3',
                                                'A4',
                                                'A7',
                                                'A8',
                                                'AA',
                                              ];
                                              final degreeCode =
                                                  degreeCodes[index];
                                              if (selectedDegreeFilters
                                                  .contains(degreeCode)) {
                                                selectedDegreeFilters
                                                    .remove(degreeCode);
                                              } else {
                                                selectedDegreeFilters
                                                    .add(degreeCode);
                                              }

                                              applyFilters();
                                              clearsearch();
                                            }),
                                            children: [
                                              Text(
                                                'B.E. Chem.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'B.E. E.E.E.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'B.E. Mech.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'B.E. C.S.E.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'B.E. E.N.I.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'B.E. E.C.E',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ToggleButtons(
                                            borderColor: Colors.white,
                                            isSelected: List.generate(
                                                5,
                                                (index) =>
                                                    selectedDegreeFilters2
                                                        .contains([
                                                      'B1',
                                                      'B2',
                                                      'B3',
                                                      'B4',
                                                      'B5'
                                                    ][index])),
                                            onPressed: (index) => setState(() {
                                              final degreeCodes = [
                                                'B1',
                                                'B2',
                                                'B3',
                                                'B4',
                                                'B5'
                                              ];
                                              final degreeCode =
                                                  degreeCodes[index];
                                              if (selectedDegreeFilters2
                                                  .contains(degreeCode)) {
                                                selectedDegreeFilters2
                                                    .remove(degreeCode);
                                              } else {
                                                selectedDegreeFilters2
                                                    .add(degreeCode);
                                              }

                                              applyFilters();
                                            }),
                                            children: [
                                              Text(
                                                'M.Sc. Bio.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'M.Sc. Chem.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'M.Sc. Eco.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'M.Sc. Math',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'M.Sc. Physics',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () => setState(() {
                                                  searchController.clear();
                                                  selectedYearFilters.clear();
                                                  selectedDegreeFilters.clear();
                                                  selectedDegreeFilters2
                                                      .clear();
                                                  filteredStudents = students;
                                                }),
                                                child: Text('Clear Filters'),
                                              ),
                                              SizedBox(
                                                width: 100,
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    Navigator.of(context).pop,
                                                child: Text('Apply Filters'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                      },
                    ),
                    const Text(
                      'FILTERS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomTheme.darkPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        putrequest();
                      });
                    },
                    child: Text(
                      'Hide your CGPA',
                      style: TextStyle(color: Colors.white),
                    )),
                Text(
                  'RESULTS: $totalFilteredStudents',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 10,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: CustomTheme.darkScaffoldColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: const [
                            BoxShadow(
                              color: CustomTheme.darkSecondaryColor,
                              offset: Offset(2.5, 2.5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${filteredStudents[index].name}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 58,
                                      width: 58,
                                      decoration: BoxDecoration(
                                        color: CustomTheme.darkScaffoldColor,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(width: 3),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color:
                                                CustomTheme.darkSecondaryColor,
                                            width: 3, // Border width
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1,
                                                      vertical: 1),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 0),
                                                decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .darkSecondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: const Text(
                                                  'CGPA',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (filteredStudents[index].show ==
                                                'true')
                                              Text(
                                                '${filteredStudents[index].cgpa}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              _buildTag(filteredStudents[index].campusId),
                              _buildTag(codetobranch[filteredStudents[index]
                                  .campusId
                                  .substring(4, 6)]),
                              if (filteredStudents[index]
                                      .campusId
                                      .substring(6, 7) ==
                                  'A')
                                _buildTag(codetobranch[filteredStudents[index]
                                    .campusId
                                    .substring(6, 8)]),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: CustomTheme.darkSecondaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${filteredStudents[index].hostel} - ${filteredStudents[index].room}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomTheme.darkScaffoldColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFBDBDBD),
          width: 0.1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void toggleYearFilter(int index) {
    setState(() {
      final year = [2023, 2022, 2021, 2020, 2019, 2018][index];
      if (selectedYearFilters.contains(year)) {
        selectedYearFilters.remove(year);
      } else {
        selectedYearFilters.add(year);
      }
      applyFilters();
      clearsearch();
    });
  }

  void toggleDegreeFilter(int index) {
    setState(() {
      final degreeCodes = [
        'A1',
        'A3',
        'A4',
        'A7',
        'A8',
        'AA',
      ];
      final degreeCode = degreeCodes[index];
      if (selectedDegreeFilters.contains(degreeCode)) {
        selectedDegreeFilters.remove(degreeCode);
      } else {
        selectedDegreeFilters.add(degreeCode);
      }

      applyFilters();
      clearsearch();
    });
  }

  void toggleDegreeFilter2(int index) {
    setState(() {
      final degreeCodes = ['B1', 'B2', 'B3', 'B4', 'B5'];
      final degreeCode = degreeCodes[index];
      if (selectedDegreeFilters2.contains(degreeCode)) {
        selectedDegreeFilters2.remove(degreeCode);
      } else {
        selectedDegreeFilters2.add(degreeCode);
      }

      applyFilters();
    });
  }

  void applyFilters() {
    setState(() {
      filteredStudents = students
          .where((student) =>
              (selectedYearFilters.isEmpty || selectedYearFilters.contains(int.parse(student.campusId.toString().substring(0, 4)))) &&
              (selectedDegreeFilters.isEmpty && selectedDegreeFilters2.isEmpty ||
                  selectedDegreeFilters2.isEmpty &&
                      selectedDegreeFilters.any((code) => student.campusId
                          .toString()
                          .substring(4, 8)
                          .contains(code)) ||
                  selectedDegreeFilters.isEmpty &&
                      selectedDegreeFilters2.any((code) => student.campusId
                          .toString()
                          .substring(4, 8)
                          .contains(code)) ||
                  selectedDegreeFilters2.any((code) => student.campusId
                          .toString()
                          .substring(4, 8)
                          .contains(code)) &&
                      selectedDegreeFilters
                          .any((code) => student.campusId.toString().substring(4, 8).contains(code))))
          .toList();
    });
  }

  Future<http.Response> putrequest() async {
    final response = await http.put(Uri.parse(hide),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "campus_id": "2022B4AA0950G",
        }));
    Phoenix.rebirth(context);
    print(response.body);

    return response;
  }

  Map codetobranch = {
    "A1": "Chemical",
    "A3": "E.E.E.",
    "A4": "Mechanical",
    "A7": "C.S.E.",
    "A8": "E.N.I.",
    "AA": "E.C.E.",
    "B1": "M.Sc. Bio.",
    "B2": "M.Sc. Chem.",
    "B3": "M.Sc. Eco.",
    "B4": "M.Sc. Math",
    "B5": "M.Sc. Physics",
  };
}

void main() {
  runApp(Phoenix(
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardList(),
    ),
  ));
}
