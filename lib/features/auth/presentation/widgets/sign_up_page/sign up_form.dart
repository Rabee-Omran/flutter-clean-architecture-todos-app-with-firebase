import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../../injection_container.dart';
import '../../../../todo/presentation/bloc/get_todos/todo_bloc.dart';
import '../../../../todo/presentation/pages/todos_page.dart';
import '../../bloc/auth_bloc.dart';
import 'sign_up_submit_buttons.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool _obscureText = false;

  final pass = TextEditingController();

  SizedBox space = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined),
              labelText: 'Email',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some Email';
              }
              return null;
            },
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
            keyboardType: TextInputType.emailAddress,
          ),
          space,
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onChanged: (val) {
              setState(() {
                password = val;
              });
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some Password';
              }
              return null;
            },
          ),
          space,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'password not match';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 40,
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthErrorState) {
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              } else if (state is AuthErrorState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);
              } else if (state is LoadedUserState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => BlocProvider<TodoBloc>(
                              create: (context) =>
                                  sl<TodoBloc>()..add(GetAllTodosEvent()),
                              child: TodosPage(),
                            )),
                    (_) => false);
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return LoadingWidget();
              }
              return SignUpSubmitButtons(
                  formKey: _formKey, email: email, password: password);
            },
          )
        ],
      ),
    );
  }
}
