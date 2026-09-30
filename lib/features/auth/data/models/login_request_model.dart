class LoginRequestModel {
  const LoginRequestModel({
    required this.fullPhoneNumber,
    required this.password,
  });

  final String fullPhoneNumber;
  final String password;

  Map<String, dynamic> toJson() {
    return {'fullPhoneNumber': fullPhoneNumber, 'password': password};
  }
}
