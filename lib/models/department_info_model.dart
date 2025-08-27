// department_model.dart

class DepartmentInfoModel {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final List<ImageModel> images;
  final List<DoctorModel> doctors;

  DepartmentInfoModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.doctors,
  });

  factory DepartmentInfoModel.fromJson(Map<String, dynamic> json) {
    // تحويل قائمة الصور
    final imagesList = json['images'] as List? ?? [];
    final images = imagesList.map((item) => ImageModel.fromJson(item)).toList();

    // تحويل قائمة الأطباء
    final doctorsList = json['doctors'] as List? ?? [];
    final doctors =
        doctorsList.map((item) => DoctorModel.fromJson(item)).toList();

    return DepartmentInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      images: images,
      doctors: doctors,
    );
  }
}

// نموذج الصورة
class ImageModel {
  final int id;
  final String path;
  final int departmentId;

  ImageModel({
    required this.id,
    required this.path,
    required this.departmentId,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as int,
      path: json['path'] as String,
      departmentId: json['department_id'] as int,
    );
  }
}

// نموذج الطبيب
class DoctorModel {
  final int id;
  final String name;
  final int departmentId;

  DoctorModel({
    required this.id,
    required this.name,
    required this.departmentId,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      departmentId: json['department_id'] as int,
    );
  }
}
