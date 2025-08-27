// models/balance_model.dart

class GetBalanceModel {
  final double balance;

  GetBalanceModel({required this.balance});

  factory GetBalanceModel.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return GetBalanceModel(balance: 0.0);
    }

    final balanceString = json[0] as String? ?? '0.0';
    final balanceDouble = double.tryParse(balanceString) ?? 0.0;

    return GetBalanceModel(balance: balanceDouble);
  }
}
