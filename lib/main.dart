// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Student {
  late String career;
  late String campusId;
  late String name;
  late double cgpa;

  Student(
      {required this.career,
      required this.campusId,
      required this.name,
      required this.cgpa});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      career: json['career'],
      campusId: json['campus id'],
      name: json['name'],
      cgpa: json['cgpa'].toDouble(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student List',
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late List<Student> students;
  late List<Student> filteredStudents;
  late TextEditingController searchController;
  Set<int> selectedYearFilters = {};
  Set<String> selectedDegreeFilters = {};
  @override
  void initState() {
    super.initState();
    students = [];
    fetchData();
    filteredStudents = students;
    searchController = TextEditingController();
  }

  Future<String> fetchData() async {
    var response = await http.get(Uri.parse(
        "https://script.googleusercontent.com/a/macros/goa.bits-pilani.ac.in/echo?user_content_key=azql5-hY5nuUKiEaNNhGeV6P2AMSJ4sDO7OBvPxT_sIrzW1vOnajfDQb7bqb7yTyC_NM_jvo4YxYeerSSr9Fw18aAdVWTewJOJmA1Yb3SEsKFZqtv3DaNYcMrmhZHmUMi80zadyHLKARtYr68iRiYzh--Rhw3lucFnQTGeO8l-VLhyHCd5hHa5uZquTSJeY7IWTBvFxgWbR_yD0o2iWHO2YgYYoGwBetW32vV8u8ZhX5R1IdciS-NMawiQ0qvNPvceBhoiDBx3QAgyM7bBF5Nw&lib=MSEyvIiv8YNtrN875YbmWHqR0-IiIPqXW"));

    setState(() {
      var extractdata = json.decode(response.body);
      var tempList = extractdata['data'] as List;
      students = tempList.map((json) => Student.fromJson(json)).toList();
      filteredStudents = students;
    });

    return "Success!";
  }

  void search(String query) {
    setState(() {
      filteredStudents = students
          .where((student) =>
              (selectedYearFilters.isEmpty ||
                  selectedYearFilters.contains(int.parse(
                      student.campusId.toString().substring(0, 4)))) &&
              (selectedDegreeFilters.isEmpty ||
                  selectedDegreeFilters.every(
                      (code) => student.campusId.toString().contains(code))) &&
              (student.name.toLowerCase().contains(query.toLowerCase()) ||
                  student.campusId.toString().contains(query)))
          .toList();
    });
  }

  void clear() {
    setState(() {
      searchController.clear();
      selectedYearFilters.clear();
      selectedDegreeFilters.clear();
      filteredStudents = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalFilteredStudents = filteredStudents.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('BPGC Everyone'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleButtons(
                  children: [
                    Text('2022'),
                    Text('2023'),
                    Text('2021'),
                    Text('2020'),
                    Text('2019'),
                    Text('2018'),
                  ],
                  isSelected: List.generate(
                      6,
                      (index) => selectedYearFilters.contains(
                          [2022, 2023, 2021, 2020, 2019, 2018][index])),
                  onPressed: (index) => toggleYearFilter(index),
                ),
                ToggleButtons(
                  children: [
                    Text('A1'),
                    Text('A3'),
                    Text('A4'),
                    Text('A7'),
                    Text('A8'),
                    Text('AA'),
                    Text('B1'),
                    Text('B2'),
                    Text('B3'),
                    Text('B4'),
                    Text('B5'),
                  ],
                  isSelected: List.generate(
                      11,
                      (index) => selectedDegreeFilters.contains([
                            'A1',
                            'A3',
                            'A4',
                            'A7',
                            'A8',
                            'AA',
                            'B1',
                            'B2',
                            'B3',
                            'B4',
                            'B5'
                          ][index])),
                  onPressed: (index) => toggleDegreeFilter(index),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                labelText: 'Search by name or ID',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clear,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: clear,
            child: Text('Clear Filters'),
          ),
          SizedBox(height: 10),
          Text('$totalFilteredStudents'),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredStudents[index].name),
                  subtitle: Text(
                      'ID: ${filteredStudents[index].campusId} | CGPA: ${filteredStudents[index].cgpa} | Career: ${filteredStudents[index].career}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void toggleYearFilter(int index) {
    setState(() {
      final year = [2022, 2023, 2021, 2020, 2019, 2018][index];
      if (selectedYearFilters.contains(year)) {
        selectedYearFilters.remove(year);
      } else {
        selectedYearFilters.add(year);
      }
      applyFilters();
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
        'B1',
        'B2',
        'B3',
        'B4',
        'B5'
      ];
      final degreeCode = degreeCodes[index];
      if (selectedDegreeFilters.contains(degreeCode)) {
        selectedDegreeFilters.remove(degreeCode);
      } else {
        selectedDegreeFilters.add(degreeCode);
      }

      applyFilters();
    });
  }

  void applyFilters() {
    setState(() {
      filteredStudents = students
          .where((student) =>
              (selectedYearFilters.isEmpty ||
                  selectedYearFilters.contains(int.parse(
                      student.campusId.toString().substring(0, 4)))) &&
              (selectedDegreeFilters.isEmpty ||
                  selectedDegreeFilters.every((code) => student.campusId
                      .toString()
                      .substring(4, 8)
                      .contains(code))))
          .toList();
    });
  }
}
