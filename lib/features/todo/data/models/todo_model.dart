import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    String? id,
    int? notificationId,
    bool? isNotificationEnabled,
    String? imageUrl,
    File? imageFile,
    required bool complete,
    required String note,
    required String task,
  }) : super(
          complete: complete,
          note: note,
          task: task,
          id: id,
          notificationId: notificationId,
          isNotificationEnabled: isNotificationEnabled,
          imageUrl: imageUrl,
          imageFile: imageFile,
        );

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'note': note,
      'complete': complete,
      'notificationId': -1,
      'isNotificationEnabled': false,
      'imageUrl': imageUrl ?? "",
    };
  }

  factory TodoModel.fromSnapshot(QueryDocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return TodoModel(
      task: data!['task'] ?? "",
      id: doc.id,
      note: data['note'] ?? "",
      complete: data['complete'] ?? false,
      notificationId: data['notificationId'] ?? null,
      isNotificationEnabled: data['isNotificationEnabled'] ?? false,
      imageUrl: data['imageUrl'] ?? "",
    );
  }

  factory TodoModel.fromEntity(Todo entity) {
    return TodoModel(
      task: entity.task,
      complete: entity.complete,
      note: entity.note,
      id: entity.id,
      notificationId: entity.notificationId,
      isNotificationEnabled: entity.isNotificationEnabled,
      imageUrl: entity.imageUrl,
      imageFile: entity.imageFile,
    );
  }

  factory TodoModel.fromJson(Map<String, Object> json) {
    return TodoModel(
      task: json['task'] as String,
      note: json['note'] as String,
      id: json['id'] as String,
      complete: json['complete'] as bool,
      notificationId: json['notificationId'] as int,
      isNotificationEnabled: json['isNotificationEnabled'] as bool,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
