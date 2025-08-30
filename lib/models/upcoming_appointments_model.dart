// models/upcoming_appointments_model.dart

import 'package:patient_project/models/ali_appointment_model.dart';

class UpcomingAppointmentsResponse {
  final List<AliAppointment> appointments;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int totalRecords;
  final String? nextPageUrl; // يمكن أن تكون null

  UpcomingAppointmentsResponse({
    required this.appointments,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.totalRecords,
    this.nextPageUrl,
  });

  factory UpcomingAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    // تحويل قائمة المواعيد
    final appointmentsList = json['appointments'] as List? ?? [];
    final appointments =
        appointmentsList.map((item) => AliAppointment.fromJson(item)).toList();

    return UpcomingAppointmentsResponse(
      appointments: appointments,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      totalRecords: json['total_records'] as int,
      nextPageUrl: json['next_page_url'] as String?,
    );
  }
}
