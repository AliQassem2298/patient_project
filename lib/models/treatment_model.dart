// lib/models/treatment_model.dart

class Treatment {
  final int id;
  final int appointmentId;
  final String description;
  final int xRay;
  final String diagnosedDisease;
  final String recoveredDisease;
  final double bill;
  var paid;

  Treatment({
    required this.id,
    required this.appointmentId,
    required this.description,
    required this.xRay,
    required this.diagnosedDisease,
    required this.recoveredDisease,
    required this.bill,
    required this.paid,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      appointmentId: json['appointment_id'],
      description: json['description'] ?? 'N/A',
      xRay: json['x_ray'] ?? 0,
      diagnosedDisease: json['diagnosed_disease'] ?? 'N/A',
      recoveredDisease: json['recovered_disease'] ?? 'N/A',
      bill: double.tryParse(json['bill']?.toString() ?? '0.0') ?? 0.0,
      paid: json['paid'] ?? 0,
    );
  }
}
