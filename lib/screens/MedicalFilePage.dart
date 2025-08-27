import 'package:flutter/material.dart';

// صفحة جديدة لملف المريض الطبي مع أقسام مفصلة للعلاجات، الأدوية، والفواتير
class MedicalFilePage extends StatefulWidget {
  const MedicalFilePage({super.key});

  @override
  State<MedicalFilePage> createState() => _MedicalFilePageState();
}

class _MedicalFilePageState extends State<MedicalFilePage> {
  // قائمة من الخرائط لتخزين معلومات طبية مفصلة لكل علاج.
  final List<Map<String, dynamic>> _treatments = [
    {
      'diagnosis': 'داء السكري من النوع الثاني',
      'previousIllness': 'ارتفاع ضغط الدم',
      'treatmentReceived': 'العلاج بالأنسولين',
      'radiologyNeeded': false,
    },
    {
      'diagnosis': 'كسر في عظمة الكعبرة',
      'previousIllness': 'لا توجد مشاكل سابقة في العظام',
      'treatmentReceived': 'تجبير وجلسات علاج طبيعي',
      'radiologyNeeded': true,
    },
  ];

  // قائمة لاستعادة قسم الأدوية مع تفاصيل جديدة
  final List<Map<String, dynamic>> _medications = [
    {
      'doctor': 'د. أحمد محمود',
      'date': '2023-08-25',
      'name': 'ميتفورمين',
      'dosage': 'قرص واحد يومياً',
      'instructions': 'يؤخذ مع الطعام',
      'duration': 'شهر واحد',
    },
    {
      'doctor': 'د. فاطمة علي',
      'date': '2023-08-20',
      'name': 'ايبوبروفين',
      'dosage': 'قرصان عند اللزوم',
      'instructions': 'يؤخذ مع كمية كافية من الماء',
      'duration': 'أسبوع واحد',
    },
  ];

  // مصفوفة بوليانية بسيطة لحالة الدفع
  final List<bool> _invoicePayments = [true, false, true, false];
  
  // اللون الأساسي للتطبيق
  final Color _primaryColor = const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملف المريض الطبي', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'السجل الطبي للمريض',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // قسم العلاجات
            _buildTreatmentsSection(),
            const SizedBox(height: 24),

            // قسم الأدوية
            _buildMedicationsSection(),
            const SizedBox(height: 24),

            // قسم الفاتورة
            _buildInvoiceSection(),
          ],
        ),
      ),
    );
  }

  // دالة لبناء قسم العلاجات المفصل
  Widget _buildTreatmentsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'العلاجات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // عرض كل علاج من القائمة
            ..._treatments.map((treatment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('التشخيص: ${treatment['diagnosis']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('المرض السابق: ${treatment['previousIllness']}'),
                    const SizedBox(height: 4),
                    Text('العلاج الذي تم تلقيه: ${treatment['treatmentReceived']}'),
                    const SizedBox(height: 4),
                    Text('هل يحتاج أشعة: ${treatment['radiologyNeeded'] ? 'نعم' : 'لا'}'),
                    const Divider(height: 24),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  // دالة جديدة لاستعادة قسم الأدوية
  Widget _buildMedicationsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأدوية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final medication = _medications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('اسم الدواء: ${medication['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('الطبيب المعالج: ${medication['doctor']}'),
                      const SizedBox(height: 4),
                      Text('تاريخ الوصفة: ${medication['date']}'),
                      const SizedBox(height: 4),
                      Text('الجرعة: ${medication['dosage']}'),
                      const SizedBox(height: 4),
                      Text('طريقة الاستعمال: ${medication['instructions']}'),
                      const SizedBox(height: 4),
                      Text('مدة العلاج: ${medication['duration']}'),
                      const Divider(height: 24),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء قسم الفاتورة الجديد (مصفوفة بوليانية فقط)
  Widget _buildInvoiceSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الفاتورة والدفع',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // عرض كل بند من بنود الفاتورة وحالة الدفع
            ..._invoicePayments.asMap().entries.map((entry) {
              final index = entry.key;
              final isPaid = entry.value;
              return SwitchListTile(
                title: Text('دفع الفاتورة ${index + 1}'),
                value: isPaid,
                onChanged: (bool newValue) {
                  setState(() {
                    _invoicePayments[index] = newValue;
                  });
                },
                secondary: Icon(
                  isPaid ? Icons.check_circle : Icons.pending,
                  color: isPaid ? Colors.green : Colors.red,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
