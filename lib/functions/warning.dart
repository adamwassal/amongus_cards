import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Warning {
  static Future<void> showWarningDialog(
    BuildContext context,
    String ar,
    String en,
    [VoidCallback? function]
  ) async {
    final storage = FlutterSecureStorage();
    String? lang = await storage.read(key: "lang");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(lang == "ar" ? ar : en,style: TextStyle(color: Colors.red),textAlign: TextAlign.center,),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Now context is defined
                if (function != null) {
                  function();
                }
              },
              child: Text(lang == "ar" ? "حسنا" : "OK", 
                  style: TextStyle(fontSize: 30, color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
