// models/prescription_model.dart

class GetPrescriptionsModel {
  final List<Prescription> prescriptions;

  GetPrescriptionsModel({required this.prescriptions});

  factory GetPrescriptionsModel.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return GetPrescriptionsModel(prescriptions: []);
    }

    // نأخذ أول عنصر، وهو القائمة الداخلية
    final List<dynamic> prescriptionsList = json[0] is List ? json[0] : json;
    final List<Prescription> prescriptions =
        prescriptionsList.map((item) => Prescription.fromJson(item)).toList();

    return GetPrescriptionsModel(prescriptions: prescriptions);
  }
}

class Prescription {
  final int id;
  final int patientId;
  final int doctorId;
  final String date;
  final String createdAt;
  final String updatedAt;
  final List<Medicine> medicines;

  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.medicines,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    final List<dynamic> medicinesList = json['medicines'] as List? ?? [];
    final List<Medicine> medicines =
        medicinesList.map((item) => Medicine.fromJson(item)).toList();

    return Prescription(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      doctorId: json['doctor_id'] as int,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      medicines: medicines,
    );
  }
}

class Medicine {
  final int id;
  final int patientId;
  final String scientificName;
  final String tradeName;
  final int quantity;
  final int price;
  final String image;
  final String createdAt;
  final String updatedAt;

  // الحقول من pivot (مهمة جدًا)
  final int dose;
  final String instructions;
  final String finishDate;
  final String pivotCreatedAt;
  final String pivotUpdatedAt;

  Medicine({
    required this.id,
    required this.patientId,
    required this.scientificName,
    required this.tradeName,
    required this.quantity,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.dose,
    required this.instructions,
    required this.finishDate,
    required this.pivotCreatedAt,
    required this.pivotUpdatedAt,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    // استخراج pivot
    final pivot = json['pivot'] as Map<String, dynamic>? ?? {};

    return Medicine(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      scientificName: json['scientific_name'] as String,
      tradeName: json['trade_name'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as int,
      image: json['image'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      // من pivot
      dose: pivot['dose'] as int? ?? 0,
      instructions: pivot['instructions'] as String? ?? '',
      finishDate: pivot['finish_date'] as String? ?? '',
      pivotCreatedAt: pivot['created_at'] as String? ?? '',
      pivotUpdatedAt: pivot['updated_at'] as String? ?? '',
    );
  }
}
