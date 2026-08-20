class VerifyPinResponse {
  final String transactionToken;

  VerifyPinResponse({required this.transactionToken});

  factory VerifyPinResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPinResponse(
      transactionToken: json['transaction_token'],
    );
  }
}