import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';

class DeleteCommentService {
  Future<void> deleteComment({required int commentId}) async {
    await Api().delete(
      url: '$baseUrl/deleteComment/$commentId',
      token: sharedPreferences!.getString('token'),
    );
  }
}
