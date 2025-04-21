import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  String? generatedCode;

  // هذا المتغير لتخزين قائمة الطلاب الذين قاموا بالمسح
  List<Map<String, String>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceList();
  }

  // لتحميل قائمة الحضور من SharedPreferences
  Future<void> _loadAttendanceList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedList = prefs.getStringList('attendance_students') ?? [];

    setState(() {
      attendanceList = storedList
          .map((e) => Map<String, String>.from(json.decode(e)))
          .toList();
    });
  }

  // لتخزين بيانات الحضور في SharedPreferences
  Future<void> _saveAttendance(String name, String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedList = prefs.getStringList('attendance_students') ?? [];

    Map<String, String> studentData = {
      'name': name,
      'studentId': studentId,
    };

    storedList.add(json.encode(studentData));
    await prefs.setStringList('attendance_students', storedList);

    // تحديث العرض
    _loadAttendanceList();
  }

  void generateNewQRCode() async {
    DateTime now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";
    String randomCode = (1000 + Random().nextInt(9000)).toString();  // كود عشوائي

    String newCode = "LECTURE-$randomCode-$date";

    setState(() {
      generatedCode = newCode;
    });

    await saveCode(newCode);
  }

  Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> codesList = prefs.getStringList('attendance_codes') ?? [];

    String entry = json.encode({
      'code': code,
      'timestamp': DateTime.now().toIso8601String(),
    });

    codesList.add(entry);

    await prefs.setStringList('attendance_codes', codesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة الدكتور',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'كود الحضور للمحاضرة',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    generatedCode != null
                        ? QrImageView(
                      data: generatedCode!,
                      size: 200,
                      backgroundColor: Colors.white,
                    )
                        : const Text(
                      'مرحبا يا دكتور من فضلك اضغط على الزر لإنشاء كود جديد',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: generateNewQRCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'إنشاء كود جديد',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showAttendanceList(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'قائمة الطلاب الحاضرين',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // هذه الدالة لعرض جدول الحضور
  void _showAttendanceList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("قائمة الطلاب الحاضرين"),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text('اسم الطالب')),
                DataColumn(label: Text('الرقم الجامعي')),
              ],
              rows: attendanceList.map((student) {
                return DataRow(cells: [
                  DataCell(Text(student['name'] ?? '')),
                  DataCell(Text(student['studentId'] ?? '')),
                ]);
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}