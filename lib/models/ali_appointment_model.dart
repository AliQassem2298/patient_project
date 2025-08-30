// appointment_model.dart

class AliAppointmentModel {
  final List<AliAppointment> appointments;

  AliAppointmentModel({required this.appointments});

  factory AliAppointmentModel.fromJson(Map<String, dynamic> json) {
    var appointmentList = json['appointments'] as List;
    List<AliAppointment> appointments =
        appointmentList.map((item) => AliAppointment.fromJson(item)).toList();

    return AliAppointmentModel(appointments: appointments);
  }
}

class AliAppointment {
  final int id;
  final int doctorId;
  final int patientId;
  final String date;
  final String time;
  final int isBooked;
  final String appointmentTime;
  final String createdAt;
  final String updatedAt;

  AliAppointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.time,
    required this.isBooked,
    required this.appointmentTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AliAppointment.fromJson(Map<String, dynamic> json) {
    return AliAppointment(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      patientId: json['patient_id'] as int,
      date: json['date'] as String,
      time: json['time'] as String,
      isBooked: json['is_booked'] as int,
      appointmentTime: json['appointment_time'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
