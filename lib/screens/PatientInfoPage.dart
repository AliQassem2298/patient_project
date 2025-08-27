// screens/patient_info_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import 'package:patient_project/helper/api.dart';
import 'package:patient_project/models/patient_profile_model.dart';
import 'package:patient_project/services/personal_info_service.dart';

class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  String? _gender;
  bool _isEditing = false;
  late Future<PatientProfileModel> _infoFuture;
  final PersonalInfoService _service = PersonalInfoService();

  @override
  void initState() {
    super.initState();
    _infoFuture = _service.personalInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // إعادة تحميل البيانات
  Future<void> _refreshInfo() async {
    setState(() {
      _infoFuture = _service.personalInfo();
    });
  }

  // تحميل البيانات من الـ Future
  void _loadFromFuture(PatientProfileModel data) {
    _nameController.text = data.name;
    _phoneController.text = data.phone;
    _addressController.text = data.location;
    _dateOfBirthController.text = _formatDisplayDate(data.birthDate);
    _gender = data.gender;
  }

  // تنسيق تاريخ الميلاد للعرض (من iso إلى DD-MM-YYYY)
  String _formatDisplayDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return isoDate; // إذا كان الشكل غير صحيح
    }
  }

  // تحويل العكس: من DD-MM-YYYY إلى ISO
  String _parseToIso(String displayDate) {
    try {
      final parts = displayDate.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day).toIso8601String();
      }
    } catch (e) {
      return displayDate;
    }
    return displayDate;
  }

  // اختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  // حفظ التحديثات (في المستقبل ستتصل بـ API)
  void _updatePatientInfo() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث المعلومات بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isEditing = false;
      });
      // هنا يمكنك إرسال البيانات إلى الخادم
      // مثلاً: UpdatePatientService().update(...)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملفي الشخصي', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<PatientProfileModel>(
        future: _infoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  const SizedBox(height: 10),
                  Text('خطأ: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshInfo,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          // تحميل البيانات عند بناء الواجهة
          _loadFromFuture(snapshot.data!);

          final data = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshInfo,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // الصورة أو الحرف الأول
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepPurple[100],
                      backgroundImage: data.image != null
                          ? NetworkImage('$baseUrlImage${data.image!}')
                          : null,
                      child: data.image == null
                          ? Text(
                              data.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'معلوماتي الشخصية',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // الاسم
                    TextFormField(
                      controller: _nameController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: TextEditingController(text: _gender ?? ''),
                      readOnly:
                          true, // فقط للقراءة (نسمح بالتعديل لاحقًا إذا داعي)
                      decoration: InputDecoration(
                        labelText: 'النوع',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.accessibility),
                        // عند التعديل، يمكن نغير اللون أو الحدود
                      ),
                      // لا نستخدم enabled: false
                    ),
                    const SizedBox(height: 16),
                    // تاريخ الميلاد
                    TextFormField(
                      controller: _dateOfBirthController,
                      readOnly: !_isEditing,
                      onTap: _isEditing ? () => _selectDate(context) : null,
                      decoration: InputDecoration(
                        labelText: 'تاريخ الميلاد (يوم-شهر-سنة)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال تاريخ الميلاد';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // رقم الهاتف
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // العنوان
                    TextFormField(
                      controller: _addressController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                        labelText: 'العنوان',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.home),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال العنوان';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // زر الحفظ أو التعديل
                    _isEditing
                        ? ElevatedButton.icon(
                            onPressed: _updatePatientInfo,
                            icon: const Icon(Icons.save),
                            label: const Text('حفظ التغييرات'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('تعديل المعلومات'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
