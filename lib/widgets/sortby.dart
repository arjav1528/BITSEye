import 'package:flutter/material.dart';
import 'package:newproject2/custom_theme.dart';
import 'package:newproject2/models/student.dart';

import 'package:google_fonts/google_fonts.dart';

class SortDropdownButton extends StatefulWidget {
  final List<Student> students;
  final VoidCallback? onSort;
  const SortDropdownButton({super.key, required this.students, this.onSort});

  @override
  _SortDropdownButtonState createState() => _SortDropdownButtonState();
}

class _SortDropdownButtonState extends State<SortDropdownButton> {
  String _selectedSortOption = 'Sort';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: CustomTheme.darkPrimaryColor,
      style: GoogleFonts.jost(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      value: _selectedSortOption,
      onChanged: (String? newValue) {
        setState(() {
          _selectedSortOption = newValue!;
        });
        if (newValue == 'Sort') {
          return unsort();
        } else if (newValue == 'Sort by CGPA') {
          sortcgpa();
        } else if (newValue == 'Sort by Name') {
          sortname();
        } else if (newValue == 'Sort by Hostel') {
          sorthostel();
        }
        widget.onSort?.call();
      },
      items: <String>['Sort', 'Sort by CGPA', 'Sort by Name', 'Sort by Hostel']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void unsort() {
    setState(() {
      widget.students.shuffle();
    });
  }

  void sortname() {
    widget.students.sort((a, b) => a.name.compareTo(b.name));
  }

  void sorthostel() {
    setState(() {
      widget.students.sort((a, b) => a.room!.compareTo(b.room!));
    });
  }

  void sortcgpa() {
    setState(() {
      widget.students.sort((b, a) {
        if (a.show == 'true' && b.show == 'true') {
          return a.cgpa.compareTo(b.cgpa);
        } else {
          return 0;
        }
      });
    });
  }
}
