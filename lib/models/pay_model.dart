// models/payment_response_model.dart

class PaymentResponseModel {
  final String message;
  final int balance;

  PaymentResponseModel({
    required this.message,
    required this.balance,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      message: json['message'] as String,
      balance: json['balance'] as int,
    );
  }
}
