import 'package:flutter/material.dart';

import '../app_themes.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;

  const LoadingWidget({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: color != null ? color : secondaryColor,
          ),
        ),
      ),
    );
  }
}
