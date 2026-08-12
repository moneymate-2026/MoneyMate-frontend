
    class Loginmodel {
      final String email;
      final String password;
      final String pin;

      Loginmodel({
        required this.email,
        required this.password,
        required this.pin
      });

      Map<String, dynamic> toJson() {
        return {
          "email": email,
          "password": password,
          'pin':pin
        };
      }
    }

