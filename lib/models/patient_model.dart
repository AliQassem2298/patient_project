// // lib/models/patient_model.dart

// class Patient {
//   final int id;
//   final String name;
//   final String phone;
//   final String birthDate;
//   final double walletBalance;
//   final bool eyestrain;
//   final bool astigmatism;
//   final bool pressure;
//   final bool diabtes;
//   final bool colorBlindness;
//   final bool strabismus;
//   final bool allergy;
//   final bool dryEye;
//   final bool retinalDetachment;
//   final bool keratoconus;
//   final bool conjunctivitis;
//   final bool cataract;
//   final bool glaucoma;

//   Patient({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.birthDate,
//     required this.walletBalance,
//     required this.eyestrain,
//     required this.astigmatism,
//     required this.pressure,
//     required this.diabtes,
//     required this.colorBlindness,
//     required this.strabismus,
//     required this.allergy,
//     required this.dryEye,
//     required this.retinalDetachment,
//     required this.keratoconus,
//     required this.conjunctivitis,
//     required this.cataract,
//     required this.glaucoma,
//   });

//   factory Patient.fromJson(Map<String, dynamic> json) {
//     return Patient(
//       id: json['id'],
//       name: json['name'] ?? 'N/A',
//       phone: json['phone'] ?? 'N/A',
//       birthDate: json['birth_date'] ?? 'N/A',
//       walletBalance:
//           double.tryParse(json['wallet_balance']?.toString() ?? '0.0') ?? 0.0,
//       eyestrain: json['Eyestrain'] == 1,
//       astigmatism: json['Astigmatism'] == 1,
//       pressure: json['pressure'] == 1,
//       diabtes: json['diabtes'] == 1,
//       colorBlindness: json['Color_blindness'] == 1,
//       strabismus: json['Strabismus'] == 1,
//       allergy: json['allergy'] == 1,
//       dryEye: json['Dry_eye'] == 1,
//       retinalDetachment: json['Retinal_detachment'] == 1,
//       keratoconus: json['Keratoconus'] == 1,
//       conjunctivitis: json['Conjunctivitis'] == 1,
//       cataract: json['Cataract'] == 1,
//       glaucoma: json['Glaucoma'] == 1,
//     );
//   }
// }

// lib/models/patient_model.dart

import 'package:patient_project/models/appointment_model.dart';

class Patient {
  final int id;
  final String name;
  final String phone;
  final String birthDate;
  final double walletBalance;
  final bool eyestrain;
  final bool astigmatism;
  final bool pressure;
  final bool diabtes;
  final bool colorBlindness;
  final bool strabismus;
  final bool allergy;
  final bool dryEye;
  final bool retinalDetachment;
  final bool keratoconus;
  final bool conjunctivitis;
  final bool cataract;
  final bool glaucoma;
  final List<Appointment> appointments;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.birthDate,
    required this.walletBalance,
    required this.eyestrain,
    required this.astigmatism,
    required this.pressure,
    required this.diabtes,
    required this.colorBlindness,
    required this.strabismus,
    required this.allergy,
    required this.dryEye,
    required this.retinalDetachment,
    required this.keratoconus,
    required this.conjunctivitis,
    required this.cataract,
    required this.glaucoma,
    required this.appointments,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    final List<dynamic> appointmentsJson = json['appointments'] ?? [];
    final appointments = appointmentsJson
        .map((appointmentJson) => Appointment.fromJson(appointmentJson))
        .toList();

    return Patient(
      id: json['id'],
      name: json['name'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      birthDate: json['birth_date'] ?? 'N/A',
      walletBalance:
          double.tryParse(json['wallet_balance']?.toString() ?? '0.0') ?? 0.0,
      eyestrain: json['Eyestrain'] == 1,
      astigmatism: json['Astigmatism'] == 1,
      pressure: json['pressure'] == 1,
      diabtes: json['diabtes'] == 1,
      colorBlindness: json['Color_blindness'] == 1,
      strabismus: json['Strabismus'] == 1,
      allergy: json['allergy'] == 1,
      dryEye: json['Dry_eye'] == 1,
      retinalDetachment: json['Retinal_detachment'] == 1,
      keratoconus: json['Keratoconus'] == 1,
      conjunctivitis: json['Conjunctivitis'] == 1,
      cataract: json['Cataract'] == 1,
      glaucoma: json['Glaucoma'] == 1,
      appointments: appointments,
    );
  }
}
