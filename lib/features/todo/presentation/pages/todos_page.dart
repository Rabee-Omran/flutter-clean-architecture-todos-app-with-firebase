import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/widgets/logout_button.dart';
import '../bloc/add_delete_update_todo/add_delete_update_todo_bloc.dart';
import '../bloc/get_todos/todo_bloc.dart';
import '../bloc/internet_moniter/internet_monitor_bloc.dart';
import '../widgets/add_floating_button.dart';
import '../widgets/no_internet.dart';
import '../widgets/todo_item.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: AddFloatingButton());
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/app-icon.png'),
        ),
      ),
      title: Text(
        "Todos",
      ),
      actions: [LogoutButton()],
    );
  }

  Widget _buildBody() {
    return BlocListener<AddDeleteUpdateTodoBloc, AddDeleteUpdateTodoState>(
      listener: (context, state) async {
        await Future.delayed(Duration(milliseconds: 200), () {
          if (state is TodoErrorState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is TodoMessageState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
          }
        });
      },
      child: _buildConnectionMoniter(),
    );
  }

  Widget _buildConnectionMoniter() {
    return Builder(builder: (context) {
      final connectionState = context.watch<InternetMonitorBloc>().state;

      if (connectionState is InternetConnectionDisconnected) {
        return NoInternet();
      } else if (connectionState is InternetConnectionLoading) {
        return LoadingWidget();
      } else {
        return _buildTodos();
      }
    });
  }

  BlocBuilder<TodoBloc, TodoState> _buildTodos() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is LoadedTodosState) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: state.todos
                  .map((todo) => TodoItem(
                        todo: todo,
                      ))
                  .toList(),
            ),
          );
        } else if (state is TodosErrorState) {
          return NoInternet();
        } else if (state is TodoLoadingState || state is TodoInitialState) {
          return LoadingWidget();
        }

        return Container();
      },
    );
  }
}
