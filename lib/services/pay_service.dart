import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/pay_model.dart';

class PayService {
  Future<PaymentResponseModel> pay({
    required int treatmentId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/pay',
      body: {
        "treatment_id": treatmentId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return PaymentResponseModel.fromJson(data);
  }
}
