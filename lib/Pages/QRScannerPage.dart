import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';  // Update this import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentqr/Pages/StudentRegisterPage.dart';

class QRScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مسح كود الحضور'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blueAccent,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: qrText != null
                  ? Text(
                'الكود المقروء: $qrText',
                style: TextStyle(fontSize: 18, color: Colors.green),
              )
                  : Text(
                'امسح كود الحضور',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> checkCodeValidity(String? scannedCode) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> codesList = prefs.getStringList('attendance_codes') ?? [];

    for (var jsonItem in codesList) {
      var item = json.decode(jsonItem);
      if (item['code'] == scannedCode) {
        return true;
      }
    }
    return false;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();  // وقف الكاميرا بعد المسح
      final code = scanData.code;

      bool isValid = await checkCodeValidity(code);

      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StudentRegisterPage(code: code ?? "unknown")),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('خطأ'),
            content: Text('الكود غير صحيح!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();  // يرجع يفتح الكاميرا
                },
                child: Text('إعادة المحاولة'),
              )
            ],
          ),
        );
      }
    });
  }
}