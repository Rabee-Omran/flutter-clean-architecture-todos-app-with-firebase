import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exception.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> loginUser({required Map authData});
  Future<User> registerUser({required Map authData});
  Future<User> googleSignInOrSignUp();
  Future<bool> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebaseAuth.FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({required this.auth, required this.googleSignIn});

  firebaseAuth.User? get getCurrentUser => auth.currentUser;

  @override
  Future<User> loginUser({required Map authData}) async {
    try {
      final firebaseUser = await auth.signInWithEmailAndPassword(
        email: authData['email'],
        password: authData['password'],
      );

      final User user = User(
        id: firebaseUser.user!.uid,
        username: firebaseUser.user!.displayName ?? "",
        email: firebaseUser.user!.email ?? "",
        image: firebaseUser.user!.photoURL ?? "",
      );
      return Future.value(user);
    } on firebaseAuth.FirebaseAuthException catch (e) {
      throw FirebaseDataException(e.message!);
    }
  }

  @override
  Future<User> registerUser({required Map authData}) async {
    try {
      final firebaseUser = await auth.createUserWithEmailAndPassword(
        email: authData['email'],
        password: authData['password'],
      );

      final User user = User(
        id: firebaseUser.user!.uid,
        username: firebaseUser.user!.displayName ?? "",
        email: firebaseUser.user!.email ?? "",
        image: firebaseUser.user!.photoURL ?? "",
      );

      return Future.value(user);
    } on firebaseAuth.FirebaseAuthException catch (e) {
      throw FirebaseDataException(e.message!);
    }
  }

  @override
  Future<User> googleSignInOrSignUp() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) throw (CanceledByUserException());
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final firebaseAuth.AuthCredential credential =
          firebaseAuth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);

      final User user = User(
        id: googleSignInAccount.id,
        username: googleSignInAccount.displayName ?? "",
        email: googleSignInAccount.email,
        image: googleSignInAccount.photoUrl ?? "",
      );

      return Future.value(user);
    } on firebaseAuth.FirebaseAuthException catch (e) {
      throw FirebaseDataException(e.message!);
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();

      return true;
    } catch (e) {
      throw (OfflineException);
    }
  }
}
