// screens/doctor_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import 'package:patient_project/models/doctor_profile_model.dart';
import 'package:patient_project/screens/AvailableAppointmentsScreen.dart';
import 'package:patient_project/services/getdoctorbyid_service.dart';

class DoctorProfileScreen extends StatefulWidget {
  final int doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late Future<DoctorProfileResponse> _profileFuture;
  final GetdoctorbyidService _service = GetdoctorbyidService();
  @override
  void initState() {
    super.initState();
    _profileFuture = _service.getdoctorbyid(doctorId: widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 30),
        child: FloatingActionButton.extended(
          label: const Text(
            'احجز الآن',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AvailableAppointmentsScreen(doctorId: widget.doctorId),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: const Text('ملف الطبيب'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {
          _profileFuture = _service.getdoctorbyid(doctorId: widget.doctorId);
        }),
        child: FutureBuilder<DoctorProfileResponse>(
          future: _profileFuture,
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
                    Text('خطأ: ${snapshot.error}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _profileFuture =
                            _service.getdoctorbyid(doctorId: widget.doctorId);
                      }),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('لا توجد بيانات'));
            }

            final doctor = snapshot.data!.doctorProfile;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // صورة الطبيب
                Hero(
                  tag: 'doctor_${doctor.id}',
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      doctor.name[0],
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // الاسم
                Text(
                  doctor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // الخبرة
                Text(
                  '${doctor.yearsOfExperience} سنة خبرة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),

                // التفاصيل
                _buildDetailTile('التخصص', 'طب عام'),
                _buildDetailTile('سنة التخرج', doctor.graduationDate),
                _buildDetailTile('مكان الدراسة', doctor.studyPlace),
                _buildDetailTile('التقييم', '${doctor.stars} نجمة'),
                _buildDetailTile('المفضل', doctor.isFavorite ? 'نعم' : 'لا'),

                const SizedBox(height: 30),

                // الشهادات
                const Text(
                  'الشهادات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (doctor.certificates.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctor.certificates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cert = doctor.certificates[index];
                      return Card(
                        color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(cert.name),
                        ),
                      );
                    },
                  )
                else
                  const Text('لا توجد شهادات',
                      style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 30),

                // القسم: التعليقات
                const Text(
                  'التعليقات من المرضى',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (doctor.comments.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctor.comments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final comment = doctor.comments[index];
                      final date = _formatDate(comment.createdAt);
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // رأس التعليق: اسم المريض أو "مريض #"
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'مريض #${comment.patientId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                comment.content,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'في: $date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  const Text(
                    'لا توجد تعليقات بعد',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // تنسيق التاريخ إلى: 26 أغسطس 2025
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy - hh:mm a').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }
}
