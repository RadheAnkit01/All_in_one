import 'package:all_in_one/core/database/daos/user_dao.dart';
import 'package:all_in_one/features/auth/data/models/user_model.dart';
import 'package:all_in_one/features/auth/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';

class UserLocalDataSource {
  UserLocalDataSource({required this._userDao});

  final UserDao _userDao;

  Future<User?> getCurrentUser() async {
    debugPrint('Fetching current user from user local datasource...');
    final cachedUser = await _userDao.getCurrentUser();

    if (cachedUser == null) {
      return null;
    }

    return User(
      fullPhoneNumber: cachedUser.fullPhoneNumber,
      email: cachedUser.email,
      fname: cachedUser.firstName,
      lname: cachedUser.lastName,
      selectedCourseId: cachedUser.courseId,
      gender: cachedUser.gender,
      countryCode: cachedUser.countryCode,
    );
  }

  Future<void> saveCurrentUser(UserModel user) {
    debugPrint('Saving current user to user local datasource...');
    return _userDao.saveCurrentUser(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      gender: user.gender,
      countryCode: user.countryCode,
      fullPhoneNumber: user.fullPhoneNumber,
      courseId: user.courseId,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  Future<void> clearCurrentUser() {
    debugPrint('Clearing current user from user local datasource...');
    return _userDao.clearCurrentUser();
  }
}
