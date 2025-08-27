import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/massage_model.dart';

class AddCommentService {
  Future<MassageModel> addComment({
    required int doctorId,
    required String content,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/addComment',
      body: {
        "doctor_id": doctorId,
        "content": content,
      },
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
