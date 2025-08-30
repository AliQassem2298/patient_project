import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ConstantURL.dart';

class RequestNewContract extends StatefulWidget {
  final String token;
  const RequestNewContract({super.key, required this.token});

  @override
  State<RequestNewContract> createState() => _RequestNewContractState();
}

class _RequestNewContractState extends State<RequestNewContract> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
    }

  Future<void> _sendContractRequest() async {
    if (_selectedDate == null) {
      _showToast("Please select the end date of the new contract");
      return;
    }

    try {
      final url = Uri.parse("$baseUrl/api/requestNewContract");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'to': "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
        }),
      );

      if (response.statusCode == 200) {
        _showToast("✅ Your contract renewal request has been submitted successfully");
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        _showToast(" Error: ${error['message'] ?? 'An unexpected error occurred'}");
      }
    } catch (e) {
      _showToast(" Failed to submit the request: $e");
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
        ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
        : "No date selected";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request New Contract"),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Please select the end date of your new contract",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo',color:Colors.grey,),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickDate,
              child: const Text("Open the Calendar", style: TextStyle(fontSize: 16,color:Colors.grey,),),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today,color:Color.fromARGB(255, 129, 237, 194),),

                const SizedBox(width: 10),
                Text(formattedDate, style: const TextStyle(fontSize: 18, color:Colors.grey,)),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _sendContractRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 129, 237, 194),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.send,color: Colors.grey,),
              label: const Text(
                "Send Request",style:  TextStyle(color:Colors.grey,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
