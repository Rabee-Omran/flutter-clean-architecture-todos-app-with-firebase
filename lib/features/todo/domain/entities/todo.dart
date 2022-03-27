import 'dart:io';

import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final bool complete;
  final String note;
  final String task;
  final String? id;
  final int? notificationId;
  final bool? isNotificationEnabled;
  final String? imageUrl;
  final File? imageFile;

  Todo(
      {this.id,
      this.notificationId,
      this.isNotificationEnabled,
      this.imageUrl,
      this.imageFile,
      required this.task,
      required this.note,
      required this.complete});

  @override
  List<Object?> get props => [
        id,
        task,
        note,
        complete,
        notificationId,
        isNotificationEnabled,
        imageUrl,
        imageFile,
      ];
}
