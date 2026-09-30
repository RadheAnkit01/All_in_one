// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

import 'package:all_in_one/features/auth/domain/entities/user.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String countryCode;
  final String fullPhoneNumber;
  final int courseId;
  final String role;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.countryCode,
    required this.fullPhoneNumber,
    required this.courseId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    String? countryCode,
    String? fullPhoneNumber,
    int? courseId,
    String? role,
    String? createdAt,
    String? updatedAt,
  }) => UserModel(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    gender: gender ?? this.gender,
    countryCode: countryCode ?? this.countryCode,
    fullPhoneNumber: fullPhoneNumber ?? this.fullPhoneNumber,
    courseId: courseId ?? this.courseId,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    gender: json["gender"],
    countryCode: json["countryCode"],
    fullPhoneNumber: json["fullPhoneNumber"],
    courseId: json["courseId"],
    role: json["role"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "gender": gender,
    "countryCode": countryCode,
    "fullPhoneNumber": fullPhoneNumber,
    "courseId": courseId,
    "role": role,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };

  User toEntity() {
    return User(
      fullPhoneNUmber: fullPhoneNumber,
      email: email,
      fname: firstName,
      lname: lastName,
      selectedCourseId: courseId,
      gender: gender,
      countryCode: countryCode,
    );
  }
}
