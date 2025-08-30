import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddMedicineScreen extends StatefulWidget {
  final String baseUrl;
  final int medicineId;
  final int? prescription_id;
  final String token;
  const AddMedicineScreen({super.key, required this.baseUrl, required this.medicineId, required this.prescription_id, required this.token});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _finishDateController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {

      final response = await http.post(
        Uri.parse('${widget.baseUrl}/api/addtoPrescription'), // عدّل حسب مسار API الصحيح
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
        body: jsonEncode({
          'medicine_id': widget.medicineId,
          'prescription_id':widget.prescription_id ,
          'dose': _doseController.text.trim(),
          'finish_date': _finishDateController.text.trim(),
          'instructions': _instructionsController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // إرجاع true للصفحة السابقة كدليل نجاح الإضافة
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: ${errorData['message'] ?? 'فشل الإضافة'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الاتصال: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _doseController.dispose();
    _finishDateController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة وصفة دواء', style: GoogleFonts.cairo()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => //Navigator.pop(context, false), // إغلاق بدون إرسال
            Navigator.of(context).pop(true),

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: 'الجرعة', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال الجرعة' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _finishDateController,
                decoration: const InputDecoration(
                    labelText: 'تاريخ الانتهاء (YYYY-MM-DD)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'يرجى إدخال تاريخ الانتهاء';

                  final regex = RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$');
                  if (!regex.hasMatch(value)) return 'يرجى إدخال التاريخ بالشكل الصحيح';

                  try {
                    final inputDate = DateTime.parse(value);
                    final now = DateTime.now();

                    final today = DateTime(now.year, now.month, now.day);
                    if (!inputDate.isAfter(today)) {
                      return 'يجب أن يكون تاريخ الانتهاء بعد اليوم الحالي';
                    }
                  } catch (e) {
                    return 'التاريخ غير صالح';
                  }

                  return null; // التحقق ناجح
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'التعليمات', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال التعليمات' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('إرسال', style: GoogleFonts.cairo()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
