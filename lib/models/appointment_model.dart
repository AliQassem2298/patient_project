// lib/models/appointment_model.dart

class Appointment {
  final int id;
  final String date;
  final String time;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['date'] ?? 'N/A',
      time: json['time'] ?? 'N/A',
    );
  }
}
