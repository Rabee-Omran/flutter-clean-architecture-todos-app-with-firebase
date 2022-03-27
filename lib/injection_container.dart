import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/firebase_notification_settings.dart';
import 'core/network/network_info.dart';
import 'core/notification_settings.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/google_sign_in_or_sign_up.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/todo/data/datasources/todo_local_data_source.dart';
import 'features/todo/data/datasources/todo_remote_data_source.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/add_todo.dart';
import 'features/todo/domain/usecases/delete_todo.dart';
import 'features/todo/domain/usecases/disable_notification.dart';
import 'features/todo/domain/usecases/enable_notification.dart';
import 'features/todo/domain/usecases/get_todos.dart';
import 'features/todo/domain/usecases/update_todo.dart';
import 'features/todo/presentation/bloc/add_delete_update_todo/add_delete_update_todo_bloc.dart';
import 'features/todo/presentation/bloc/get_todos/todo_bloc.dart';
import 'features/todo/presentation/bloc/internet_moniter/internet_monitor_bloc.dart';
import 'features/todo/presentation/bloc/notification/notification_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Bloc

  sl.registerFactory(() => AuthBloc(
        getCurrentUser: sl(),
        registerUser: sl(),
        loginUser: sl(),
        logout: sl(),
        googleSignInOrSignUp: sl(),
      ));

  sl.registerFactory(() => TodoBloc(
        getTodos: sl(),
      ));

  sl.registerFactory(() => AddDeleteUpdateTodoBloc(
        addTodo: sl(),
        updateTodo: sl(),
        deleteTodo: sl(),
      ));

  sl.registerFactory(() => NotificationBloc(
        enableNotification: sl(),
        disableNotification: sl(),
      ));

  sl.registerFactory(() => InternetMonitorBloc(
        internetConnectionChecker: sl(),
      ));
  // Use cases

  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GoogleSignInOrSignUp(sl()));

  sl.registerLazySingleton(() => GetTodosUsecase(sl()));
  sl.registerLazySingleton(() => AddTodoUsecase(sl()));
  sl.registerLazySingleton(() => DeleteTodoUsecase(sl()));
  sl.registerLazySingleton(() => UpdateTodoUsecase(sl()));

  sl.registerLazySingleton(() => EnableNotificationUsecase(sl()));
  sl.registerLazySingleton(() => DisableNotificationUsecase(sl()));

  // Repository

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
      notificationService: sl(),
    ),
  );

  // Data sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(auth: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  AuthLocalDataSourceImpl authLocalDataSource =
      AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(authLocalDataSource: authLocalDataSource),
  );

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final NotificationService notificationService = NotificationService();
  final FirebaseNotificationService firebaseNotificationService =
      FirebaseNotificationService();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => messaging);
  sl.registerLazySingleton(() => notificationService);
  sl.registerLazySingleton(() => firebaseNotificationService);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => _googleSignIn);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
