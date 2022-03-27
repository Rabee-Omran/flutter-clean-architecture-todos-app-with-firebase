import '../../../../core/app_themes.dart';
import 'package:flutter/material.dart';

import '../widgets/sign_in_page/sign_in_form.dart';
import 'sign%20up_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 150,
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildForm(),
                  ],
                ),
              ),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Align _buildSignUpButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('New here ? ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => SignUpPage()));
            },
            child: Text('Sign Up !',
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Padding _buildForm() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SignInForm(),
    );
  }

  Column _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 80),
        buildLogo(),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
              text: "To",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              children: [
                TextSpan(
                    text: "dos",
                    style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))
              ]),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildLogo() {
    return Container(
      height: 100,
      width: 100,
      child: Center(child: Image.asset("assets/images/app-icon.png")),
    );
  }
}
