// ignore_for_file: unused_field, invalid_use_of_visible_for_testing_member
import 'dart:io';

import 'package:firebase_clean_architecture_app/core/app_themes.dart';
import 'package:firebase_clean_architecture_app/core/widgets/loading_widget.dart';
import 'package:firebase_clean_architecture_app/features/todo/presentation/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/todo.dart';
import '../bloc/add_delete_update_todo/add_delete_update_todo_bloc.dart';

class AddEditPage extends StatefulWidget {
  final bool isEditing;
  final Todo? todo;

  AddEditPage({
    Key? key,
    required this.isEditing,
    this.todo,
  }) : super(key: key);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _task = "";
  String _note = "";
  bool isComplete = false;
  File? _image;
  String? _imageUrl = "";

  Future getImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _imageUrl = _image!.path;
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    isComplete = widget.todo?.complete ?? false;
    _imageUrl = widget.todo?.imageUrl ?? "";
    super.initState();
  }

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Todo" : "Add Todo",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                _bulidTaskInput(),
                SizedBox(
                  height: 10,
                ),
                _buildIsCompleteCheckbox(),
                SizedBox(
                  height: 10,
                ),
                _buildNoteInput(),
                SizedBox(
                  height: 20,
                ),
                widget.isEditing ? _buildInitialImage() : _buildImage(),
                SizedBox(
                  height: 50,
                ),
                BlocConsumer<AddDeleteUpdateTodoBloc, AddDeleteUpdateTodoState>(
                  listener: (context, state) async {
                    if (state is TodoMessageState) {
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    if (state is TodoLoadingState) {
                      return LoadingWidget();
                    }
                    return _buildAddEditButton(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialImage() {
    final todoImageUrl = widget.todo?.imageUrl ?? "";

    if (todoImageUrl != _imageUrl || _imageUrl!.isEmpty) {
      return _buildImage();
    }
    return GestureDetector(
        onTap: () => getImage(), child: CachedImage(imageUrl: _imageUrl!));
  }

  Widget _buildImage() {
    if (_imageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () => getImage(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
              width: 100,
              height: 100,
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              )),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: () => getImage(),
      icon: Icon(
        FontAwesomeIcons.camera,
        color: secondaryColor,
      ),
      label: Text(
        'Select image',
        style: TextStyle(color: secondaryColor),
      ),
      style: OutlinedButton.styleFrom(side: BorderSide(color: secondaryColor)),
    );
  }

  SizedBox _buildAddEditButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            widget.isEditing
                ? BlocProvider.of<AddDeleteUpdateTodoBloc>(context).add(
                    UpdateTodoEvent(Todo(
                        id: widget.todo!.id,
                        task: _task,
                        note: _note,
                        imageFile: _image,
                        imageUrl: _imageUrl,
                        complete: isComplete)))
                : BlocProvider.of<AddDeleteUpdateTodoBloc>(context)
                    .add(AddTodoEvent(Todo(
                    task: _task,
                    note: _note,
                    complete: isComplete,
                    imageFile: _image,
                    imageUrl: _imageUrl,
                  )));
          }
        },
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)))),
        child: Text(
          isEditing ? "Update" : "Add",
        ),
      ),
    );
  }

  TextFormField _buildNoteInput() {
    return TextFormField(
      initialValue: isEditing ? widget.todo!.note : '',
      maxLines: 10,
      decoration: InputDecoration(
        prefixIcon: Icon(FontAwesomeIcons.noteSticky),
        hintText: "note",
      ),
      onSaved: (value) => _note = value!,
    );
  }

  Row _buildIsCompleteCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            overlayColor: MaterialStateProperty.all(secondaryColor),
            fillColor: MaterialStateProperty.all(secondaryColor),
            shape: CircleBorder(),
            value: isComplete,
            onChanged: (val) {
              setState(() {
                isComplete = val!;
              });
            }),
        Text("Complete")
      ],
    );
  }

  Widget _bulidTaskInput() {
    return TextFormField(
      initialValue: isEditing ? widget.todo!.task : '',
      autofocus: !isEditing,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.task_outlined),
        hintText: "task",
      ),
      validator: (val) {
        return val!.trim().isEmpty ? "Please Enter Your task" : null;
      },
      onSaved: (value) => _task = value!,
    );
  }
}
