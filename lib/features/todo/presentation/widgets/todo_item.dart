import 'cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/app_themes.dart';
import '../../domain/entities/todo.dart';
import '../bloc/add_delete_update_todo/add_delete_update_todo_bloc.dart';
import '../pages/add_edit_page.dart';
import 'notification_button.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(todo.id),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: ScrollMotion(),
        children: [
          _buildDeleteAction(context),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => AddEditPage(
                  isEditing: true,
                  todo: todo,
                ))),
        leading: _buildCheckbox(context),
        trailing: _buildTrailing(),
        title: _buildTaskText(context),
        subtitle: todo.note.isNotEmpty ? _buildNoteText() : null,
      ),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            todo.imageUrl!.isNotEmpty
                ? Container(
                    height: 25,
                    width: 25,
                    child: CachedImage(imageUrl: todo.imageUrl!))
                : SizedBox(),
            SizedBox(
              width: 8,
            )
          ],
        ),
        NotificationButton(todo: todo)
      ],
    );
  }

  SlidableAction _buildDeleteAction(context) {
    return SlidableAction(
      onPressed: (c) {
        BlocProvider.of<AddDeleteUpdateTodoBloc>(context)
            .add(DeleteTodoEvent(Todo(
          id: todo.id,
          task: todo.task,
          note: todo.note,
          complete: todo.complete,
        )));
      },
      foregroundColor: Colors.redAccent,
      icon: Icons.delete,
      label: 'Delete',
    );
  }

  Text _buildNoteText() {
    return Text(
      todo.note,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration:
              todo.complete ? TextDecoration.lineThrough : TextDecoration.none),
    );
  }

  Container _buildTaskText(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Text(
        todo.task,
        style: TextStyle(
            decoration: todo.complete
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
    );
  }

  Checkbox _buildCheckbox(BuildContext context) {
    return Checkbox(
      overlayColor: MaterialStateProperty.all(secondaryColor),
      fillColor: MaterialStateProperty.all(secondaryColor),
      shape: CircleBorder(),
      value: todo.complete,
      onChanged: (v) {
        BlocProvider.of<AddDeleteUpdateTodoBloc>(context).add(UpdateTodoEvent(
            Todo(
                id: todo.id,
                task: todo.task,
                note: todo.note,
                notificationId: todo.notificationId,
                isNotificationEnabled: todo.isNotificationEnabled,
                imageUrl: todo.imageUrl ?? "",
                complete: !todo.complete)));
      },
    );
  }
}
