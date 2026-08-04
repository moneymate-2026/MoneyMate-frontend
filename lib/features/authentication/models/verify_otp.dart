 class Verifyotprequest {
  final String email;
  final String code;

   Verifyotprequest({
     required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
  return {
'email': email,
    'code': code,  
     };
   }
 }