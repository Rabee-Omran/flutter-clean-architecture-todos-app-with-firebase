import 'package:shared_preferences/shared_preferences.dart';

abstract class TodoLocalDataSource {}

const CACHED_TODOS = 'CACHED_TODOS';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});
}
