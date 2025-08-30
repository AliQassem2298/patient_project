// class Appointment {
//   final int id;
//   final int doctorId;
//   final int patientId;
//   final String clock;
//   final int day;
//   final int month;
//   final DateTime appointmentTime;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final Patient patient;
//
//   Appointment({
//     required this.id,
//     required this.doctorId,
//     required this.patientId,
//     required this.clock,
//     required this.day,
//     required this.month,
//     required this.appointmentTime,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.patient,
//   });
//
//   factory Appointment.fromJson(Map<String, dynamic> json) {
//     return Appointment(
//       id: json['id'],
//       doctorId: json['doctor_id'],
//       patientId: json['patient_id'],
//       clock: json['clock'],
//       day: json['day'],
//       month: json['month'],
//       appointmentTime: DateTime.parse(json['appointment_time']),
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       patient: Patient.fromJson(json['patient']),
//     );
//   }
// }
//
// class Patient {
//   final int id;
//   final String name;
//
//   Patient({required this.id, required this.name});
//
//   factory Patient.fromJson(Map<String, dynamic> json) {
//     return Patient(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }


class Appointment {
  final int id;
  final int doctorId;
  final int patientId;
  final String date; // موجود في JSON
  final String time; // موجود في JSON
  final int isBooked;
  final DateTime appointmentTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Patient patient;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.time,
    required this.isBooked,
    required this.appointmentTime,
    required this.createdAt,
    required this.updatedAt,
    required this.patient,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      date: json['date'],
      time: json['time'],
      isBooked: json['is_booked'],
      appointmentTime: DateTime.parse(json['appointment_time']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      patient: Patient.fromJson(json['patient']),
    );
  }
}

class Patient {
  final int id;
  final String? name; // Nullable لأن القيمة ممكن تكون null

  Patient({required this.id, this.name});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
    );
  }
}
