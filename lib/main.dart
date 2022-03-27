import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app_themes.dart';
import 'core/firebase_notification_settings.dart';
import 'core/notification_settings.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/todo/presentation/bloc/add_delete_update_todo/add_delete_update_todo_bloc.dart';
import 'features/todo/presentation/bloc/get_todos/todo_bloc.dart';
import 'features/todo/presentation/bloc/internet_moniter/internet_monitor_bloc.dart';
import 'features/todo/presentation/bloc/notification/notification_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  await sl<NotificationService>().init();
  await sl<FirebaseNotificationService>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => sl<AuthBloc>()..add(GetCurrentUserEvent())),
          BlocProvider(create: (_) => sl<TodoBloc>()),
          BlocProvider(create: (_) => sl<AddDeleteUpdateTodoBloc>()),
          BlocProvider(create: (_) => sl<NotificationBloc>()),
          BlocProvider<InternetMonitorBloc>(
            create: (_) =>
                sl<InternetMonitorBloc>()..add(InternetMonitorEvent()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todos',
          theme: appTheme,
          home: SplashScreen(),
        ));
  }
}
