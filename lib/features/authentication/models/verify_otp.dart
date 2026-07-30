 class Verifyotprequest {
  final String email;
  final String otp;

  Verifyotprequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': otp,  
    };
  }
}