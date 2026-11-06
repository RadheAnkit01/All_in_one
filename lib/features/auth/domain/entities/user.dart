class User {
  const User({
    required this.fullPhoneNumber,
    required this.email,
    required this.fname,
    required this.lname,
    required this.selectedCourseId,
    required this.gender,
    required this.countryCode,
  });

  final String? fullPhoneNumber;
  final String? email;
  final String? fname;
  final String? lname;
  final int? selectedCourseId;
  final String? countryCode;
  final String? gender;
}
