class Transferrazomodel {
  final String toHandle;
  final String amount;
  final String idempotencyKey;
  final String description;
  final String categoryId;
  final String transactionToken;

  Transferrazomodel({
    required this.toHandle,
    required this.amount,
    required this.idempotencyKey,
    required this.description,
    required this.categoryId,
    required this.transactionToken
  });

  Map<String, dynamic> toJson() {
    return {
      'to_handle': toHandle,
      'amount': amount,
      'idempotency_key': idempotencyKey,
      'description': description,
      'category_id': categoryId,
      "transaction_token":transactionToken
    };
  }
}