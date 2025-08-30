import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ConstantURL.dart';

class RequestVacation extends StatefulWidget {
  final String token;
  const RequestVacation({super.key, required this.token});

  @override
  State<RequestVacation> createState() => _RequestVacationState();
}

class _RequestVacationState extends State<RequestVacation> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // ✅ تم إضافة هذا السطر لفتح التقويم مباشرة عند فتح الشاشة
    Future.delayed(Duration.zero, _pickDate);
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 129, 237, 194),
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 129, 237, 194),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      _selectedDate = pickedDate;
    });
    }

  Future<void> _sendVacationRequest() async {
    if (_selectedDate == null) {
      _showToast("يرجى اختيار تاريخ الإجازة");
      return;
    }

    final today = DateTime.now();
    final minDate = today.add(const Duration(days: 1));

    if (_selectedDate!.isBefore(minDate)) {
      _showToast("تاريخ الإجازة يجب أن يكون بعد اليوم بيوم واحد على الأقل");
      return;
    }

    try {
      final url = Uri.parse("$baseUrl/api/doctor/request_vacation");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'vacation_date': "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2,'0')}-${_selectedDate!.day.toString().padLeft(2,'0')}",

        }),
      );
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        _showToast("تم إرسال طلب الإجازة بنجاح");
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        _showToast("Error: ${error['message'] ?? 'An unexpected error occurred'}");
      }
    } catch (e) {
      _showToast(" Failed to submit the request: $e");
      print("$e");
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate != null
        ?"${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2,'0')}-${_selectedDate!.day.toString().padLeft(2,'0')}"

    : "No date selected";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Vacation"),
        backgroundColor:const Color.fromARGB(255, 129, 237, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              " Choose vacation date ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo',color:Colors.grey,),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickDate,
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 129, 237, 194),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Open the Calendar",
                style: TextStyle(fontSize: 16,color:Colors.grey,),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today,color:Color.fromARGB(255, 129, 237, 194),),
                const SizedBox(width: 10),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 18, color:Colors.grey,),
                ),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _sendVacationRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 129, 237, 194),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.send, color:Colors.grey,),
              label: const Text(
                "Send Request",
                style: TextStyle(fontSize: 18, color:Colors.grey,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

