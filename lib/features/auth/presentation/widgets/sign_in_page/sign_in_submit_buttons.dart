import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/auth_bloc.dart';

class SignInSubmitButtons extends StatelessWidget {
  const SignInSubmitButtons({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.email,
    required this.password,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final String? email;
  final String? password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Map authData = {
                  "email": email,
                  "password": password,
                };
                BlocProvider.of<AuthBloc>(context)
                    .add(LoginUserEvent(authData));
              }
            },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            child: const Text('Sign In'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text("Or"),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(GoogleSignInSignUp());
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Sign In with Google'),
                Icon(FontAwesomeIcons.google)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
