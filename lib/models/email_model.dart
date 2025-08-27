// models/patient_profile_model.dart

class EmailModel {
  final String email;
  EmailModel({
    required this.email,
  });

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      email: json['email'] as String,
    );
  }
}
