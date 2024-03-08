import 'package:flutter/material.dart';
import 'package:newproject2/custom_theme.dart';
import 'dart:convert';
import 'package:newproject2/models/student.dart';
import 'package:newproject2/services/getdata.dart';
import 'package:newproject2/services/putdata.dart';
import 'package:newproject2/services/search.dart';
import 'package:newproject2/widgets/sortby.dart';
import 'package:newproject2/widgets/tag.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/html.dart' as html;
// import 'package:toggle_switch/toggle_switch.dart';

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
  Set<String> selectedHostelFilters = {};

  Map codetobranch = {
    "A1": "ChemE",
    "A3": "E.E.E.",
    "A4": "Mech.",
    "A7": "C.S.E.",
    "A8": "E.N.I.",
    "AA": "E.C.E.",
    "B1": "M.Sc. Bio.",
    "B2": "M.Sc. Chem.",
    "B3": "M.Sc. Eco.",
    "B4": "M.Sc. Math",
    "B5": "M.Sc. Physics",
  };

  @override
  void initState() {
    super.initState();
    students = [];
    fetchData();
    filteredStudents = students;
    searchController = TextEditingController();
  }

  Future<List> fetchData() async {
    var response = await Fetch().fetchStudents();

    var response2 = await Fetch().fetchHostels();

    setState(() {
      final Map<String, dynamic> data = json.decode(response)['data'];
      final Map<String, dynamic> data2 = json.decode(response2);

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
      students.shuffle();
      filteredStudents = students;
    });

    return filteredStudents;
  }

  void search(String query) {
    setState(() {
      filteredStudents = students
          .where((student) =>
              (selectedYearFilters.isEmpty || selectedYearFilters.contains(int.parse(student.campusId.toString().substring(0, 4)))) &&
              (selectedHostelFilters.isEmpty ||
                  selectedHostelFilters.contains(student.hostel)) &&
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
              (Search().namesearch(query, student) ||
                  student.campusId.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  void clear() {
    setState(() {
      searchController.clear();
      selectedYearFilters.clear();
      selectedDegreeFilters.clear();
      selectedDegreeFilters2.clear();
      selectedHostelFilters.clear();
      filteredStudents = students;
    });
  }

  // void clearsearch() {
  //   setState(() {
  //     searchController.clear();
  //     filteredStudents = students;
  //   });
  // }
  int yearindex = 0;
  int beindex = 0;
  int mscindex = 0;
  int ahindex = 0;
  int chindex = 0;
  int dhindex = 0;
  @override
  Widget build(BuildContext context) {
    var uri = Uri.parse(html.window.location.href);
    var paramValue = uri.queryParameters['id'];
    Student user = students.firstWhere(
        (element) => element.campusId == paramValue,
        orElse: () => Student(campusId: '', name: '', cgpa: 0, show: 'true'));
    // print(user.show);
    int totalFilteredStudents = filteredStudents.length;

    return Scaffold(
      backgroundColor: CustomTheme.darkScaffoldColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.darkScaffoldColor,
        title: Text(
          'BPGC EVERYONE',
          style: GoogleFonts.jost(
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
              style: GoogleFonts.jost(
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
                labelStyle: GoogleFonts.jost(
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clear,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.001),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomTheme.darkPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Filters',
                              style: GoogleFonts.jost(color: Colors.white)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) => StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
                                        actionsAlignment:
                                            MainAxisAlignment.start,
                                        actionsPadding:
                                            const EdgeInsets.all(8.0),
                                        backgroundColor:
                                            CustomTheme.darkPrimaryColorVariant,
                                        title: Text(
                                          'Filters',
                                          style: GoogleFonts.jost(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    'Year',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  const Expanded(
                                                    child: Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children:
                                                    List.generate(6, (index) {
                                                  final year = [
                                                    2023,
                                                    2022,
                                                    2021,
                                                    2020,
                                                    2019,
                                                    2018,
                                                  ][index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: FilterChip(
                                                      showCheckmark: false,
                                                      selectedColor: CustomTheme
                                                          .darkSecondaryColor,
                                                      backgroundColor:
                                                          CustomTheme
                                                              .darkScaffoldColor,
                                                      label: Text(
                                                        '$year',
                                                        style: GoogleFonts.jost(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      selected:
                                                          selectedYearFilters
                                                              .contains(year),
                                                      onSelected: (isSelected) {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedYearFilters
                                                                .add(year);
                                                          } else {
                                                            selectedYearFilters
                                                                .remove(year);
                                                          }
                                                          applyFilters();

                                                          searchController
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 10),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    'B.E.',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  const Expanded(
                                                    child: Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children:
                                                    List.generate(6, (index) {
                                                  final degreeCodes = [
                                                    'A1',
                                                    'A3',
                                                    'A4',
                                                    'A7',
                                                    'A8',
                                                    'AA'
                                                  ];
                                                  final degreeCode =
                                                      degreeCodes[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: FilterChip(
                                                      showCheckmark: false,
                                                      selectedColor: CustomTheme
                                                          .darkSecondaryColor,
                                                      backgroundColor:
                                                          CustomTheme
                                                              .darkScaffoldColor,
                                                      label: Text(
                                                        codetobranch[
                                                            degreeCode],
                                                        style: GoogleFonts.jost(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      selected:
                                                          selectedDegreeFilters
                                                              .contains(
                                                                  degreeCode),
                                                      onSelected: (isSelected) {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedDegreeFilters
                                                                .add(
                                                                    degreeCode);
                                                          } else {
                                                            selectedDegreeFilters
                                                                .remove(
                                                                    degreeCode);
                                                          }
                                                          applyFilters();
                                                          searchController
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    'M.Sc.',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  const Expanded(
                                                    child: Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children:
                                                    List.generate(5, (index) {
                                                  final degreeCodes = [
                                                    'B1',
                                                    'B2',
                                                    'B3',
                                                    'B4',
                                                    'B5'
                                                  ];
                                                  final degreeCode =
                                                      degreeCodes[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: FilterChip(
                                                      showCheckmark: false,
                                                      selectedColor: CustomTheme
                                                          .darkSecondaryColor,
                                                      backgroundColor:
                                                          CustomTheme
                                                              .darkScaffoldColor,
                                                      label: Text(
                                                        codetobranch[
                                                            degreeCode],
                                                        style: GoogleFonts.jost(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      selected:
                                                          selectedDegreeFilters2
                                                              .contains(
                                                                  degreeCode),
                                                      onSelected: (isSelected) {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedDegreeFilters2
                                                                .add(
                                                                    degreeCode);
                                                          } else {
                                                            selectedDegreeFilters2
                                                                .remove(
                                                                    degreeCode);
                                                          }
                                                          applyFilters();
                                                          searchController
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    'A-hostels',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  const Expanded(
                                                    child: Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children:
                                                    List.generate(9, (index) {
                                                  final hostel = [
                                                    'AH1',
                                                    'AH2',
                                                    'AH3',
                                                    'AH4',
                                                    'AH5',
                                                    'AH6',
                                                    'AH7',
                                                    'AH8',
                                                    'AH9'
                                                  ][index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: FilterChip(
                                                      showCheckmark: false,
                                                      selectedColor: CustomTheme
                                                          .darkSecondaryColor,
                                                      backgroundColor:
                                                          CustomTheme
                                                              .darkScaffoldColor,
                                                      label: Text(
                                                        hostel,
                                                        style: GoogleFonts.jost(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      selected:
                                                          selectedHostelFilters
                                                              .contains(hostel),
                                                      onSelected: (isSelected) {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedHostelFilters
                                                                .add(hostel);
                                                          } else {
                                                            selectedHostelFilters
                                                                .remove(hostel);
                                                          }
                                                          applyFilters();
                                                          searchController
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    'C-Hostels',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  const Expanded(
                                                    child: Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children:
                                                    List.generate(7, (index) {
                                                  final hostel = [
                                                    'CH1',
                                                    'CH2',
                                                    'CH3',
                                                    'CH4',
                                                    'CH5',
                                                    'CH6',
                                                    'CH7'
                                                  ][index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: FilterChip(
                                                      showCheckmark: false,
                                                      selectedColor: CustomTheme
                                                          .darkSecondaryColor,
                                                      backgroundColor:
                                                          CustomTheme
                                                              .darkScaffoldColor,
                                                      label: Text(
                                                        hostel,
                                                        style: GoogleFonts.jost(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      selected:
                                                          selectedHostelFilters
                                                              .contains(hostel),
                                                      onSelected: (isSelected) {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedHostelFilters
                                                                .add(hostel);
                                                          } else {
                                                            selectedHostelFilters
                                                                .remove(hostel);
                                                          }
                                                          applyFilters();
                                                          searchController
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    'D-Hostels',
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  const Expanded(
                                                    child: Divider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children:
                                                    List.generate(6, (index) {
                                                  final hostel = [
                                                    'DH1',
                                                    'DH2',
                                                    'DH3',
                                                    'DH4',
                                                    'DH5',
                                                    'DH6'
                                                  ][index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: FilterChip(
                                                      showCheckmark: false,
                                                      selectedColor: CustomTheme
                                                          .darkSecondaryColor,
                                                      backgroundColor:
                                                          CustomTheme
                                                              .darkScaffoldColor,
                                                      label: Text(
                                                        hostel,
                                                        style: GoogleFonts.jost(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      selected:
                                                          selectedHostelFilters
                                                              .contains(hostel),
                                                      onSelected: (isSelected) {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedHostelFilters
                                                                .add(hostel);
                                                          } else {
                                                            selectedHostelFilters
                                                                .remove(hostel);
                                                          }
                                                          applyFilters();
                                                          searchController
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () => setState(() {
                                                  searchController.clear();
                                                  selectedYearFilters.clear();
                                                  selectedDegreeFilters.clear();
                                                  selectedDegreeFilters2
                                                      .clear();
                                                  selectedYearFilters.clear();
                                                  selectedHostelFilters.clear();
                                                  filteredStudents = students;
                                                  clear();
                                                }),
                                                child: Text(
                                                  'Clear Filters',
                                                  style: GoogleFonts.jost(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    Navigator.of(context).pop,
                                                child: Text('Apply Filters',
                                                    style: GoogleFonts.jost(
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                          },
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
                            Hide().putrequest(paramValue!);
                            html.window.location.reload();
                          });
                        },
                        child: Text(
                          (user.show == 'true') ? 'Hide CG' : 'Unhide CG',
                          style: GoogleFonts.jost(color: Colors.white),
                        )),
                    SortDropdownButton(
                      students: filteredStudents,
                      onSort: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Text(
                  'RESULTS: $totalFilteredStudents',
                  style: GoogleFonts.jost(
                    fontSize: 10.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.63,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredStudents[index].name,
                                      style: GoogleFonts.jost(
                                        textStyle: const TextStyle(
                                          overflow: TextOverflow.fade,
                                        ),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
                                            width: 3,
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
                                                child: Text(
                                                  'CGPA',
                                                  style: GoogleFonts.jost(
                                                    fontSize: 7,
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
                                                style: GoogleFonts.jost(
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
                          subtitle: Wrap(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Buildtag(
                                          text:
                                              filteredStudents[index].campusId),
                                      Buildtag(
                                          text: codetobranch[
                                              filteredStudents[index]
                                                  .campusId
                                                  .substring(4, 6)]),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  if (filteredStudents[index]
                                          .campusId
                                          .substring(6, 7) ==
                                      'A')
                                    Buildtag(
                                        text: codetobranch[
                                            filteredStudents[index]
                                                .campusId
                                                .substring(6, 8)]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 5),
                            decoration: BoxDecoration(
                              color: CustomTheme.darkSecondaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: (filteredStudents[index].hostel != '' &&
                                    filteredStudents[index].room != 'NA')
                                ? Text(
                                    '${filteredStudents[index].hostel}-${filteredStudents[index].room}',
                                    style: GoogleFonts.jost(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void applyFilters() {
    setState(() {
      filteredStudents = students
          .where((student) =>
              (selectedYearFilters.isEmpty || selectedYearFilters.contains(int.parse(student.campusId.toString().substring(0, 4)))) &&
              (selectedHostelFilters.isEmpty ||
                  selectedHostelFilters.contains(student.hostel)) &&
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
      SortDropdownButton(
          students: filteredStudents,
          onSort: () {
            setState(() {});
          });
    });
  }
}
