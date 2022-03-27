import 'package:flutter/material.dart';

import '../../../../core/app_themes.dart';

class EmptyTasks extends StatelessWidget {
  const EmptyTasks({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ImageIcon(
        AssetImage('assets/images/empty.png'),
        color: secondaryColor,
        size: 90,
      ),
    );
  }
}