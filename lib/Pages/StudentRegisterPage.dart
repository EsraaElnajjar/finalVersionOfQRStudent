import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRegisterPage extends StatefulWidget {
  final String code;
  StudentRegisterPage({required this.code});

  @override
  _StudentRegisterPageState createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadStudentData();  // استرجاع البيانات المخزنة عند فتح الصفحة
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    super.dispose();
  }

  Future<void> saveAttendance() async {
    String studentName = nameController.text.trim();
    String studentID = idController.text.trim();
    String lectureCode = widget.code;

    if (studentName.isEmpty || studentID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى ملء جميع البيانات!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // حفظ البيانات الفردية (لو حابب تحتفظ بها)
      await prefs.setString('student_name', studentName);
      await prefs.setString('student_id', studentID);
      await prefs.setString('lecture_code', lectureCode);
      await prefs.setString('attendance_date', DateTime.now().toIso8601String());

      // إضافة بيانات الطالب إلى القائمة العامة
      List<String> storedList = prefs.getStringList('attendance_students') ?? [];

      Map<String, String> studentData = {
        'name': studentName,
        'studentId': studentID,
      };

      storedList.add(json.encode(studentData));
      await prefs.setStringList('attendance_students', storedList);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل الحضور بنجاح!', style: TextStyle(color: Colors.blueAccent)),
          backgroundColor: Colors.white,
        ),
      );

      // تفريغ الحقول بعد التخزين
      nameController.clear();
      idController.clear();

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الحفظ! حاول مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
      print('SharedPreferences Error: $error');
    }
  }


  Future<void> loadStudentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // تحميل البيانات لو موجودة
    setState(() {
      nameController.text = prefs.getString('student_name') ?? '';
      idController.text = prefs.getString('student_id') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  borderRadius: BorderRadius.circular(25)),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "تسجيل بيانات الطالب",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      TextField(
                        controller: nameController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: 'اسم الطالب',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: idController,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.badge_outlined),
                          labelText: 'رقم الطالب',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: saveAttendance,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: const Text(
                            'تأكيد الحضور',
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
      ),
    );
  }
}
