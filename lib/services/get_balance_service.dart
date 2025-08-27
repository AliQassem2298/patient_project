import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/get_balance_model.dart';

class GetBalanceService {
  Future<GetBalanceModel> getBalance() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/getBalance',
      token: sharedPreferences!.getString('token'),
    );
    return GetBalanceModel.fromJson(data);
  }
}
