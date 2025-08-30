import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:patient_project/helper/api.dart';

class AddMedicalRecordPage extends StatefulWidget {
  final String token;
  const AddMedicalRecordPage({super.key, required this.token});

  @override
  State<AddMedicalRecordPage> createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  final Map<String, bool> _medicalConditions = {
    "Conjunctivitis": false,
    "Cataract": false,
    "Glaucoma": false,
    "Keratoconus": false,
    "Retinal_detachment": false,
    "Dry_eye": false,
    "Strabismus": false,
    "Color_blindness": false,
    "diabtes": false,
    "Astigmatism": false,
    "Eyestrain": false,
    "pressure": false,
    "allergy": false,
  };

  Future<void> _addMedicalRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$baseUrl/api/addMedicalInfo');
    final Map<String, dynamic> body = {
      "email": _emailController.text,
      ..._medicalConditions.map((key, value) => MapEntry(key, value ? 1 : 0)),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Record added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to the patient records page
      } else {
        // Error
        final errorBody = jsonDecode(response.body);
        String message = errorBody['message'] ?? "An unknown error occurred";
        if (response.statusCode == 422 && errorBody['errors'] != null) {
          message = errorBody['errors'].values.first[0];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Patient Record",
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ..._medicalConditions.keys.map((condition) {
                return SwitchListTile(
                  title: Text(
                    condition,
                    style: GoogleFonts.cairo(),
                  ),
                  value: _medicalConditions[condition]!,
                  onChanged: (bool value) {
                    setState(() {
                      _medicalConditions[condition] = value;
                    });
                  },
                  secondary: _medicalConditions[condition]!
                      ? const Text("Yes", style: TextStyle(color: Colors.green))
                      : const Text("No", style: TextStyle(color: Colors.red)),
                );
              }),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addMedicalRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 129, 237, 194),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Add Record",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
