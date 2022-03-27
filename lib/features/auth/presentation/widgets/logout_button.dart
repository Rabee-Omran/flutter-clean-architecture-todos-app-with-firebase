import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';
import '../pages/sign%20in_page.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        } else if (state is MessageState) {
          SnackBarMessage()
              .showSuccessSnackBar(message: state.message, context: context);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (ctx) => SignInPage()), (_) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState) return _buildLoading();
        return IconButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
            },
            icon: Icon(Icons.logout));
      },
    );
  }

  Container _buildLoading() {
    return Container(
        width: 15,
        height: 25,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: LoadingWidget());
  }
}
