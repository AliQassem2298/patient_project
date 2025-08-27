// models/patient_profile_model.dart

class PatientProfileModel {
  final String name;
  final String? image; // يمكن أن تكون null
  final String phone;
  final String gender;
  final String birthDate;
  final String location;

  PatientProfileModel({
    required this.name,
    this.image, // اختياري لأنها قد تكون null
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.location,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      name: json['name'] as String,
      image: json['image'] as String?, // قد تكون null
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      birthDate: json['birth_date'] as String,
      location: json['location'] as String,
    );
  }
}
