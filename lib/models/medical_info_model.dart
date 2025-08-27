// models/eye_conditions_model.dart

class MedicalInfoModel {
  final int eyeStrain;
  final int astigmatism;
  final int pressure;
  final int diabetes;
  final int colorBlindness;
  final int strabismus;
  final int dryEye;
  final int allergy;
  final int retinalDetachment;
  final int conjunctivitis;
  final int keratoconus;
  final int glaucoma;
  final int cataract;

  MedicalInfoModel({
    required this.eyeStrain,
    required this.astigmatism,
    required this.pressure,
    required this.diabetes,
    required this.colorBlindness,
    required this.strabismus,
    required this.dryEye,
    required this.allergy,
    required this.retinalDetachment,
    required this.conjunctivitis,
    required this.keratoconus,
    required this.glaucoma,
    required this.cataract,
  });

  factory MedicalInfoModel.fromJson(Map<String, dynamic> json) {
    return MedicalInfoModel(
      eyeStrain: json['Eyestrain'] as int,
      astigmatism: json['Astigmatism'] as int,
      pressure: json['pressure'] as int,
      diabetes:
          json['diabtes'] as int, // لاحظ: خطأ إملائي في "diabtes" من الـ API
      colorBlindness: json['Color_blindness'] as int,
      strabismus: json['Strabismus'] as int,
      dryEye: json['Dry_eye'] as int,
      allergy: json['allergy'] as int,
      retinalDetachment: json['Retinal_detachment'] as int,
      conjunctivitis: json['Conjunctivitis'] as int,
      keratoconus: json['Keratoconus'] as int,
      glaucoma: json['Glaucoma'] as int,
      cataract: json['Cataract'] as int,
    );
  }
}
