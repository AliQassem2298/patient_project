// models/doctor_profile_model.dart

class DoctorProfileResponse {
  final DoctorProfile doctorProfile;

  DoctorProfileResponse({required this.doctorProfile});

  factory DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    return DoctorProfileResponse(
      doctorProfile: DoctorProfile.fromJson(json['doctor_profile']),
    );
  }
}

class DoctorProfile {
  final int id;
  final String name;
  final int departmentId;
  final String graduationDate;
  final int yearsOfExperience;
  final String studyPlace;
  final bool isFavorite;
  final int stars;
  final List<CertificateModel> certificates;
  final List<CommentModel> comments;

  DoctorProfile({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.graduationDate,
    required this.yearsOfExperience,
    required this.studyPlace,
    required this.isFavorite,
    required this.stars,
    required this.certificates,
    required this.comments,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    // تحويل الشهادات
    final certificatesList = json['certificates'] as List? ?? [];
    final certificates = certificatesList
        .map((item) => CertificateModel.fromJson(item))
        .toList();

    // تحويل التعليقات
    final commentsList = json['comments'] as List? ?? [];
    final comments =
        commentsList.map((item) => CommentModel.fromJson(item)).toList();

    return DoctorProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      departmentId: json['department_id'] as int,
      graduationDate: json['graduation_date'] as String,
      yearsOfExperience: json['years_of_experience'] as int,
      studyPlace: json['study_place'] as String,
      isFavorite: json['is_favorite'] as bool,
      stars: json['stars'] as int,
      certificates: certificates,
      comments: comments,
    );
  }
}

// نموذج الشهادة
class CertificateModel {
  final int id;
  final int doctorId;
  final int? secretaryId;
  final String name;
  final String createdAt;
  final String updatedAt;

  CertificateModel({
    required this.id,
    required this.doctorId,
    this.secretaryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      secretaryId: json['secretary_id'] as int?,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

// نموذج التعليق - تم تحديثه ليتناسب مع الحقول الحقيقية
class CommentModel {
  final int id;
  final int doctorId;
  final int patientId;
  final String content;
  final String createdAt;
  final String updatedAt;

  CommentModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      patientId: json['patient_id'] as int,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
