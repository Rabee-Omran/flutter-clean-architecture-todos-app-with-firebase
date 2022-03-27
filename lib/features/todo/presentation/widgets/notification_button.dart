// ignore_for_file: unused_local_variable
import 'package:firebase_clean_architecture_app/core/app_themes.dart';
import 'package:firebase_clean_architecture_app/core/usecases/usecase.dart';
import 'package:firebase_clean_architecture_app/features/todo/domain/entities/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../bloc/notification/notification_bloc.dart';

class NotificationButton extends StatelessWidget {
  final Todo todo;
  const NotificationButton({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationErrorState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        } else if (state is NotificationMessageState) {
          SnackBarMessage()
              .showSuccessSnackBar(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is NotificationLoadingState) {
          if (todo.id == state.todoId) {
            return _buildLoading();
          }
        }
        return _buildIconButton(context);
      },
    );
  }

  Transform _buildLoading() {
    return Transform.scale(
      scale: 0.5,
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  Widget _buildIconButton(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (todo.isNotificationEnabled!) {
            BlocProvider.of<NotificationBloc>(context)
                .add(DisableNotificationEvent(NotificationParams(
              todo: todo,
            )));
          } else {
            DateTime? dateTime;
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            if (selectedDate != null) {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: false),
                    child: child!,
                  );
                },
              );

              if (selectedTime != null) {
                dateTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, selectedTime.hour, selectedTime.minute);

                BlocProvider.of<NotificationBloc>(context).add(
                    EnableNotificationEvent(
                        NotificationParams(todo: todo, datetime: dateTime)));
              }
            }
          }
        },
        icon: Icon(
          Icons.notification_add,
          color: todo.isNotificationEnabled! ? Colors.orange : Colors.grey,
        ));
  }
}
