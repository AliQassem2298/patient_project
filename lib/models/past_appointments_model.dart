// models/past_appointments_model.dart

import 'package:patient_project/models/appointment_model.dart';

class PastAppointmentsResponse {
  final List<Appointment> appointments;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int totalRecords;
  final String? nextPageUrl; // يمكن أن تكون null

  PastAppointmentsResponse({
    required this.appointments,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.totalRecords,
    this.nextPageUrl,
  });

  factory PastAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    // تحويل قائمة المواعيد
    final List<dynamic> appointmentsList = json['appointments'] as List? ?? [];
    final List<Appointment> appointments =
        appointmentsList.map((item) => Appointment.fromJson(item)).toList();

    return PastAppointmentsResponse(
      appointments: appointments,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      totalRecords: json['total_records'] as int,
      nextPageUrl: json['next_page_url'] as String?,
    );
  }
}
