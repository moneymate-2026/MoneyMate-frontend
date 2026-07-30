class Sendotprequest {
  final String email;

  Sendotprequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}