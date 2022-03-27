import 'package:flutter/material.dart';

import '../pages/add_edit_page.dart';

class AddFloatingButton extends StatelessWidget {
  const AddFloatingButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => AddEditPage(
                      isEditing: false,
                    )),
          );
        });
  }
}