import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String image,
  }) : super(
          id: id,
          username: username,
          email: email,
          image: image,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'image': image,
    };
  }
}
