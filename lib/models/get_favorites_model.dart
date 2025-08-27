// models/doctor_model.dart

class GetFavoritesModel {
  final int id;
  final String name;
  final String graduationDate;
  final int yearsOfExperience;
  final String studyPlace;

  GetFavoritesModel({
    required this.id,
    required this.name,
    required this.graduationDate,
    required this.yearsOfExperience,
    required this.studyPlace,
  });

  factory GetFavoritesModel.fromJson(Map<String, dynamic> json) {
    return GetFavoritesModel(
      id: json['id'] as int,
      name: json['name'] as String,
      graduationDate: json['graduation_date'] as String,
      yearsOfExperience: json['years_of_experience'] as int,
      studyPlace: json['study_place'] as String,
    );
  }
}
