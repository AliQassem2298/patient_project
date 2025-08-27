import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/department_info_model.dart';

class DepartmentInfoService {
  Future<DepartmentInfoModel> departmentInfo({
    required int id,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/department_info',
      body: {
        "id": id,
      },
      token: sharedPreferences!.getString('token'),
    );
    return DepartmentInfoModel.fromJson(data);
  }
}
