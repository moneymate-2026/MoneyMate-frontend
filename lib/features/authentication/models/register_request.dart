class RegisterRequest {
  final String fullname;
  final String phone;
  final String email;
  final String password;

  RegisterRequest({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullname,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }
}