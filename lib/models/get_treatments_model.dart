// models/medical_records_response.dart

class GetTreatmentsModel {
  final List<MedicalRecordModel> records;

  GetTreatmentsModel({required this.records});

  // ✅ توقع: json = [[{...}, {...}]]
  factory GetTreatmentsModel.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return GetTreatmentsModel(records: []);
    }

    // نأخذ أول عنصر، وهو القائمة الداخلية
    final List<dynamic> recordsJson = json[0] is List ? json[0] : json;

    final List<MedicalRecordModel> records = recordsJson
        .map(
            (item) => MedicalRecordModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return GetTreatmentsModel(records: records);
  }
}

// models/medical_record_model.dart

class MedicalRecordModel {
  final int id;
  final int appointmentId;
  final String description;
  final int xRay;
  final String diagnosedDisease;
  final String recoveredDisease;
  final int bill;
  final String clinicShare;
  final String doctorShare;
  final int paid;
  final String createdAt;
  final String updatedAt;

  MedicalRecordModel({
    required this.id,
    required this.appointmentId,
    required this.description,
    required this.xRay,
    required this.diagnosedDisease,
    required this.recoveredDisease,
    required this.bill,
    required this.clinicShare,
    required this.doctorShare,
    required this.paid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as int,
      appointmentId: json['appointment_id'] as int,
      description: json['description'] as String,
      xRay: json['x_ray'] as int,
      diagnosedDisease: json['diagnosed_disease'] as String,
      recoveredDisease: json['recovered_disease'] as String,
      bill: json['bill'] as int,
      clinicShare: json['clinic_share'] as String,
      doctorShare: json['doctor_share'] as String,
      paid: json['paid'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
