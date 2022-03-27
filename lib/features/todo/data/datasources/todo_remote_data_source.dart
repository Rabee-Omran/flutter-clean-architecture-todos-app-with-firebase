import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(TodoModel todo);
  Future<void> enabelNotification(
      {required TodoModel todoModel, required int notificationId});
  Future<void> disableNotification(NotificationParams notification);
  Stream<List<TodoModel>> todos();
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  AuthLocalDataSourceImpl authLocalDataSource;

  CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
  Reference storageRef = FirebaseStorage.instance.ref();
  TodoRemoteDataSourceImpl({
    required this.authLocalDataSource,
  });

  Future<UserModel> get currentUser async =>
      await authLocalDataSource.getCurrentUser();

  @override
  Future<void> addTodo(TodoModel todoModel) async {
    String imageUrl = todoModel.imageUrl!.isEmpty
        ? ""
        : await uploadImage(todoModel.imageFile!, todoModel.imageUrl!);

    await getCurrentUserDoc().then((userDoc) async {
      await userDoc.collection("todos").add(todoModel.toJson()
        ..addAll({
          'serverTimeStamp': FieldValue.serverTimestamp(),
          "imageUrl": imageUrl
        }));
    });
  }

  @override
  Stream<List<TodoModel>> todos() async* {
    final currentUserDoc = await getCurrentUserDoc();

    yield* currentUserDoc
        .collection("todos")
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TodoModel.fromEntity(TodoModel.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(TodoModel todoModel) async {
    await _updateOrDeleteTodo(todoModel: todoModel, isUpdate: true);
  }

  @override
  Future<void> deleteTodo(TodoModel todoModel) async {
    await _updateOrDeleteTodo(todoModel: todoModel, isUpdate: false);
  }

  Future<void> _updateOrDeleteTodo(
      {required bool isUpdate, required TodoModel todoModel}) async {
    String todoImage = todoModel.imageUrl ?? "";

    String imageUrl = todoImage.isEmpty
        ? ""
        : await uploadImage(
            todoModel.imageFile ?? File(''), todoModel.imageUrl!);

    await getCurrentUserDoc().then((userDoc) async {
      final todoDoc = userDoc.collection("todos").doc(todoModel.id);
      final bool isTodoExists = await todoDoc.get().then((todo) => todo.exists);

      if (isTodoExists) {
        isUpdate
            ? await userDoc.collection("todos").doc(todoModel.id).update(
                todoModel.toJson()
                  ..addAll({
                    'serverTimeStamp': FieldValue.serverTimestamp(),
                    "imageUrl": imageUrl
                  }))
            : await userDoc.collection("todos").doc(todoModel.id).delete();
      } else {
        throw (NotFoundException());
      }
    });
  }

  Future<DocumentReference> getCurrentUserDoc() async {
    UserModel currentUserModel = await currentUser;
    return usersRef.doc(currentUserModel.id);
  }

  @override
  Future<void> disableNotification(NotificationParams notification) async {
    await getCurrentUserDoc().then((userDoc) async {
      final todoDoc = userDoc.collection("todos").doc(notification.todo.id);
      final bool isTodoExists = await todoDoc.get().then((todo) => todo.exists);

      if (isTodoExists) {
        await userDoc.collection("todos").doc(notification.todo.id).update({
          'isNotificationEnabled': false,
        });
      } else {
        throw (NotFoundException());
      }
    });
  }

  @override
  Future<void> enabelNotification(
      {required TodoModel todoModel, required int notificationId}) async {
    await getCurrentUserDoc().then((userDoc) async {
      final todoDoc = userDoc.collection("todos").doc(todoModel.id);
      final bool isTodoExists = await todoDoc.get().then((todo) => todo.exists);

      if (isTodoExists) {
        await userDoc.collection("todos").doc(todoModel.id).update({
          'isNotificationEnabled': true,
          'notificationId': notificationId,
        });
      } else {
        throw (NotFoundException());
      }
    });
  }

  Future<String> uploadImage(File imageFile, String oldImage) async {
    return await imageFile.exists().then((isExists) async {
      if (isExists) {
        String imageName = basename(imageFile.path);
        final currentUserDoc = await getCurrentUserDoc();
        final storageImage =
            storageRef.child('todos/${currentUserDoc.id}/$imageName');

        UploadTask uploadTask = storageImage.putFile(imageFile);
        return await uploadTask.then((_) => storageImage
            .getDownloadURL()
            .whenComplete(() {})
            .then((imageUrl) => imageUrl));
      }
      return oldImage;
    });
  }
}
