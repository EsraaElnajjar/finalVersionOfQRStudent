import 'package:flutter/material.dart';
import 'package:studentqr/Pages/QRScannerPage.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool isScanning = false;
  bool scanSuccess = false;

  void startScan() async {
    setState(() {
      isScanning = true;
      scanSuccess = false;
    });

    await Future.delayed(Duration(seconds: 2)); // هنا تحط كود الاسكان الحقيقي

    setState(() {
      isScanning = false;
      scanSuccess = true;
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner,
                      size: 100,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'مسح كود الحضور',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRScannerPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        'امسح الكود الآن',
                        style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blueAccent, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(
                                child: Text(
                                  'يرجى مسح الكاميرا جيداً قبل تصوير الباركود.',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.info_outline, color: Colors.blueAccent),

                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [

                              Expanded(
                                child: Text(
                                  'يرجى التأكد من عدم وجود ثنيات أو لمعان على الباركود للحصول على نتيجة صحيحة.',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.warning_amber_outlined, color: Colors.orangeAccent),
                            ],
                          ),
                        ],
                      ),
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: scanSuccess
                          ? Column(
                        key: const ValueKey(1),
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green,
                              size: 50),
                          SizedBox(height: 10),
                          Text(
                            'تم التحقق من الكود بنجاح!',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      )
                          : const SizedBox(key: ValueKey(2)),
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
