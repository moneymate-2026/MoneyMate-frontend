class Depositordermodel {
  final String orderId;
  final String amount;
  final String keyId;

  Depositordermodel({
    required this.orderId,
    required this.amount,
    required this.keyId,
  });

  factory Depositordermodel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Depositordermodel(
      orderId: data['order_id'],
      amount: data['amount'],
      keyId: data['key_id'],
    );
  }
}