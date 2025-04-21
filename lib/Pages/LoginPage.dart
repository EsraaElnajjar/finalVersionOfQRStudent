import 'package:flutter/material.dart';
import 'package:studentqr/Pages/DoctorPage.dart';
import 'package:studentqr/Pages/StudentHome.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'دكتور'; // الدور الافتراضي

  // بيانات للدكتور والطالب
  final Map<String, String> doctorData = {
    'username': 'doctor123',
    'password': 'doctorPass',
  };

  final Map<String, String> studentData = {
    'username': 'student123',
    'password': 'studentPass',
  };

  // التحقق من بيانات تسجيل الدخول
  void _login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (selectedRole == 'دكتور') {
      // التحقق من بيانات الدكتور
      if (username == doctorData['username'] && password == doctorData['password']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorPage()), // صفحة الدكتور
        );
      } else {
        _showError('بيانات الدخول غير صحيحة للدكتور');
      }
    } else if (selectedRole == 'طالب') {
      // التحقق من بيانات الطالب
      if (username == studentData['username'] && password == studentData['password']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AttendancePage()), // صفحة الطالب
        );
      } else {
        _showError('بيانات الدخول غير صحيحة للطالب');
      }
    }
  }

  // إظهار رسالة خطأ
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 12,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.login,
                      size: 100,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // حقل إدخال اسم المستخدم
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // حقل إدخال كلمة المرور
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // اختيار الدور (دكتور أو طالب)
                    DropdownButton<String>(
                      value: selectedRole,
                      items: <String>['دكتور', 'طالب'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      style: TextStyle(color: Colors.blueAccent),
                      isExpanded: true,
                    ),
                    const SizedBox(height: 30),

                    // زر تسجيل الدخول
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
}


