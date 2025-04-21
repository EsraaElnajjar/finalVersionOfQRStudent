import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  List<Map<String, dynamic>> students = [
    {'id': '11210873', 'name': 'احمد طلعت فوزى الخولى', 'present': false},
    {'id': '11210507', 'name': 'اسماء محمد شعبان الخولى', 'present': false},
    {'id': '11210508', 'name': 'الاء ابراهيم محمد عمرو', 'present': false},
    {'id': '11210509', 'name': 'الاء عبدالجواد سليمان السرسى', 'present': false},
    {'id': '11210510', 'name': 'انسام احمد فتحى عبد العزيز حمودة', 'present': false},
    {'id': '11210512', 'name': 'ايه اشرف مليجى السيد نوفل', 'present': false},
    {'id': '11210514', 'name': 'ايه رمضان محمد عبد الحميد محمد', 'present': false},
    {'id': '11210516', 'name': 'ايه فرغلى المليجى مصطفى ابوالسعود', 'present': false},
    {'id': '11210517', 'name': 'ايه محمد عبدالغفورأحمد محمود', 'present': false},
    {'id': '11210518', 'name': 'حنان يحيى محمد احمد البندارى', 'present': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadAttendanceStatus();
  }

  Future<void> _loadAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedList = prefs.getStringList('attendance_students') ?? [];

    // استخراج قائمة الأرقام الأكاديمية للطلاب الذين سجلوا حضورهم
    List<String> attendedIds = storedList.map((jsonString) {
      Map<String, dynamic> student = json.decode(jsonString);
      return student['studentId'].toString();
    }).toList();

    // تحديث الحضور في قائمة الطلاب
    setState(() {
      for (var student in students) {
        if (attendedIds.contains(student['id'])) {
          student['present'] = true;
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('صفحة الدكتور', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _loadAttendanceStatus, // إعادة تحميل الحضور
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      color: Colors.white.withOpacity(0.85),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: student['present'] ? Colors.green : Colors.red,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          student['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("الكود: ${student['id']}"),
                        trailing: Switch(
                          value: student['present'],
                          onChanged: (val) {
                            setState(() {
                              student['present'] = val;
                            });
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
