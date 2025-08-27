import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/department_model.dart';

class GetAllDepartmentsService {
  Future<List<DepartmentModel>> getavailableappointments() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/get_all_departments',
      token: sharedPreferences!.getString('token'),
    );
    return data.map((item) => DepartmentModel.fromJson(item)).toList();
  }
}
