import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCurrentUser();
  Future<bool> logOut();

  Future<void> saveUser(UserModel userToCache);
}

const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCurrentUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveUser(UserModel userToCache) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<bool> logOut() {
    final isDone = sharedPreferences.remove(CACHED_USER);

    return isDone;
  }
}
