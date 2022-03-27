import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String image;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.image,
  });

  @override
  List<Object> get props => [
        id,
        username,
        email,
        image,
      ];
}
