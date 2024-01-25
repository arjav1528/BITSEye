// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, library_private_types_in_public_api

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:newproject2/custom_theme.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class Student {
//   late String career;
//   late String campusId;
//   late String name;
//   late double cgpa;

//   Student(
//       {required this.career,
//       required this.campusId,
//       required this.name,
//       required this.cgpa});

//   factory Student.fromJson(Map<String, dynamic> json) {
//     return Student(
//       career: json['career'],
//       campusId: json['campus id'],
//       name: json['name'],
//       cgpa: json['cgpa'].toDouble(),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Student List',
//       home: StudentListScreen(),
//     );
//   }
// }

// class StudentListScreen extends StatefulWidget {
//   const StudentListScreen({super.key});

//   @override
//   _StudentListScreenState createState() => _StudentListScreenState();
// }

// class _StudentListScreenState extends State<StudentListScreen> {
//   late List<Student> students;
//   late List<Student> filteredStudents;
//   late TextEditingController searchController;
//   Set<int> selectedYearFilters = {};
//   Set<String> selectedDegreeFilters = {};
//   Set<String> selectedDegreeFilters2 = {};
//   @override
//   void initState() {
//     super.initState();
//     students = [];
//     fetchData();
//     filteredStudents = students;
//     searchController = TextEditingController();
//   }

//   Future<String> fetchData() async {
//     var response = await http.get(Uri.parse(
//         "https://script.googleusercontent.com/macros/echo?user_content_key=9oFG5-nbsQR89eE4r5n5oogZmhqrxWce9qLCx9kD_l7zIWhdy-SgQo1xFkaQc_H1iewpkJdnafuawHzYwwIoBub4LUpYmCU7m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnJF0XyafF5tCPRJG45TClwuphImSJmzD2_KmerKfvH_c3VfAPYIocs39om-Z7p-vrsGbdeN7LRIMcubGlWg0vJgJpe0J070fvw&lib=MSEyvIiv8YNtrN875YbmWHqR0-IiIPqXW"));

//     setState(() {
//       var extractdata = json.decode(response.body);
//       var tempList = extractdata['data'] as List;
//       students = tempList.map((json) => Student.fromJson(json)).toList();
//       filteredStudents = students;
//     });

//     return "Success!";
//   }

//   void search(String query) {
//     setState(() {
//       filteredStudents = students
//           .where((student) =>
//               (selectedYearFilters.isEmpty || selectedYearFilters.contains(int.parse(student.campusId.toString().substring(0, 4)))) &&
//               (selectedDegreeFilters.isEmpty && selectedDegreeFilters2.isEmpty ||
//                   selectedDegreeFilters2.isEmpty &&
//                       selectedDegreeFilters.any((code) => student.campusId
//                           .toString()
//                           .substring(4, 8)
//                           .contains(code)) ||
//                   selectedDegreeFilters.isEmpty &&
//                       selectedDegreeFilters2.any((code) => student.campusId
//                           .toString()
//                           .substring(4, 8)
//                           .contains(code)) ||
//                   selectedDegreeFilters2.any((code) => student.campusId.toString().substring(4, 8).contains(code)) &&
//                       selectedDegreeFilters.any((code) => student.campusId
//                           .toString()
//                           .substring(4, 8)
//                           .contains(code))) &&
//               (student.name.toLowerCase().contains(query.toLowerCase()) ||
//                   student.campusId.toString().contains(query)))
//           .toList();
//     });
//   }

//   void clear() {
//     setState(() {
//       searchController.clear();
//       selectedYearFilters.clear();
//       selectedDegreeFilters.clear();
//       selectedDegreeFilters2.clear();
//       filteredStudents = students;
//     });
//   }

//   void clearsearch() {
//     setState(() {
//       searchController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     int totalFilteredStudents = filteredStudents.length;
//     return Scaffold(
//       backgroundColor: CustomTheme.darkScaffoldColor,
//       appBar: AppBar(
//         backgroundColor: CustomTheme.darkScaffoldColor,
//         title: Text(
//           'BPGC everyone',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AlertDialog(
//               title: Text(
//                 'Filters',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               content: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ToggleButtons(
//                     children: [
//                       Text('2022'),
//                       Text('2023'),
//                       Text('2021'),
//                       Text('2020'),
//                       Text('2019'),
//                       Text('2018'),
//                     ],
//                     isSelected: List.generate(
//                         6,
//                         (index) => selectedYearFilters.contains(
//                             [2022, 2023, 2021, 2020, 2019, 2018][index])),
//                     onPressed: (index) => toggleYearFilter(index),
//                   ),
//                   ToggleButtons(
//                     children: [
//                       Text('A1'),
//                       Text('A3'),
//                       Text('A4'),
//                       Text('A7'),
//                       Text('A8'),
//                       Text('AA'),
//                     ],
//                     isSelected: List.generate(
//                         6,
//                         (index) => selectedDegreeFilters.contains([
//                               'A1',
//                               'A3',
//                               'A4',
//                               'A7',
//                               'A8',
//                               'AA',
//                             ][index])),
//                     onPressed: (index) => toggleDegreeFilter(index),
//                   ),
//                   ToggleButtons(
//                     children: [
//                       Text('B1'),
//                       Text('B2'),
//                       Text('B3'),
//                       Text('B4'),
//                       Text('B5'),
//                     ],
//                     isSelected: List.generate(
//                         5,
//                         (index) => selectedDegreeFilters2
//                             .contains(['B1', 'B2', 'B3', 'B4', 'B5'][index])),
//                     onPressed: (index) => toggleDegreeFilter2(index),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: search,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: Colors.white,
//                     width: 3,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: CustomTheme.darkSecondaryColor,
//                     width: 3,
//                   ),
//                 ),
//                 labelText: 'Search by name',
//                 labelStyle: const TextStyle(
//                   color: Colors.white,
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: clearsearch,
//                 ),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: clear,
//             child: Text('Clear Filters'),
//           ),
//           SizedBox(height: 10),
//           Text('$totalFilteredStudents'),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredStudents.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(filteredStudents[index].name),
//                   subtitle: Text(
//                       'ID: ${filteredStudents[index].campusId} | CGPA: ${filteredStudents[index].cgpa} | Career: ${filteredStudents[index].career}'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void toggleYearFilter(int index) {
//     setState(() {
//       final year = [2022, 2023, 2021, 2020, 2019, 2018][index];
//       if (selectedYearFilters.contains(year)) {
//         selectedYearFilters.remove(year);
//       } else {
//         selectedYearFilters.add(year);
//       }
//       applyFilters();
//       clearsearch();
//     });
//   }

//   void toggleDegreeFilter(int index) {
//     setState(() {
//       final degreeCodes = [
//         'A1',
//         'A3',
//         'A4',
//         'A7',
//         'A8',
//         'AA',
//       ];
//       final degreeCode = degreeCodes[index];
//       if (selectedDegreeFilters.contains(degreeCode)) {
//         selectedDegreeFilters.remove(degreeCode);
//       } else {
//         selectedDegreeFilters.add(degreeCode);
//       }

//       applyFilters();
//       clearsearch();
//     });
//   }

//   void toggleDegreeFilter2(int index) {
//     setState(() {
//       final degreeCodes = ['B1', 'B2', 'B3', 'B4', 'B5'];
//       final degreeCode = degreeCodes[index];
//       if (selectedDegreeFilters2.contains(degreeCode)) {
//         selectedDegreeFilters2.remove(degreeCode);
//       } else {
//         selectedDegreeFilters2.add(degreeCode);
//       }

//       applyFilters();
//     });
//   }

//   void applyFilters() {
//     setState(() {
//       filteredStudents = students
//           .where((student) =>
//               (selectedYearFilters.isEmpty || selectedYearFilters.contains(int.parse(student.campusId.toString().substring(0, 4)))) &&
//               (selectedDegreeFilters.isEmpty && selectedDegreeFilters2.isEmpty ||
//                   selectedDegreeFilters2.isEmpty &&
//                       selectedDegreeFilters.any((code) => student.campusId
//                           .toString()
//                           .substring(4, 8)
//                           .contains(code)) ||
//                   selectedDegreeFilters.isEmpty &&
//                       selectedDegreeFilters2.any((code) => student.campusId
//                           .toString()
//                           .substring(4, 8)
//                           .contains(code)) ||
//                   selectedDegreeFilters2.any((code) => student.campusId
//                           .toString()
//                           .substring(4, 8)
//                           .contains(code)) &&
//                       selectedDegreeFilters
//                           .any((code) => student.campusId.toString().substring(4, 8).contains(code))))
//           .toList();
//     });
//   }

// //   void filtering() {
// //     setState(() {
// //           filteredStudents = students.where(
// //             (student) =>(selectedDegreeFilters.isEmpty && selectedDegreeFilters2.isEmpty) || (selectedDegreeFilters.contains(student.campusId
// //                       .toString()
// //                       .substring(4, 8)) && selectedDegreeFilters2.isEmpty) || (selectedDegreeFilters.isEmpty && selectedDegreeFilters2.contains(student.campusId
// //                       .toString()
// //                       .substring(4, 8)) || selectedDegreeFilters
// //                       ) ,
// //           ).toList();

// //     });
// //   }

// //   void filtering() {
// //     setState(() {
// //       filteredStudents = students.where(
// //         (student) =>(selectedDegreeFilters.isEmpty && selectedDegreeFilters2.isEmpty) || (selectedDegreeFilters.contains(student.campusId
// //                        .toString()
// //                        .substring(4, 8)) && selectedDegreeFilters2.isEmpty) || (selectedDegreeFilters.isEmpty && selectedDegreeFilters2.contains(student.campusId
// //                        .toString()
// //                       .substring(4, 8))
// //                        ) ||
// //                        (for(int i=0;i<selectedDegreeFilters.length;i++)
// //                        {
// //                         return true;
// //                        })
// //       ).toList();
// //     });
// //   }
// }
