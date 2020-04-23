import 'package:flutter/material.dart';
import 'bloc/todo_block.dart';
import 'data/todo.dart';
import 'main.dart';

class TodoScreen extends StatelessWidget {
  final Todo todo;
  final bool isNew;
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtCompleteBy = TextEditingController();
  final TextEditingController txtPriority = TextEditingController();

  final TodoBloc bloc;
  /*
    The part after the colon in the TodoScreen constructor is an initializer list,
    a comma-separated list that you can use to initialize final fields with
    calculated expression
  */
  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.tryParse(txtPriority.text);
    if (isNew) {
      bloc.todoInsertSink.add(todo);
    } else {
      bloc.todoUpdateSink.add(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 20.0;
    txtName.text = todo.name;
    txtDescription.text = todo.description;
    txtCompleteBy.text = todo.completeBy;
    txtPriority.text = todo.priority.toString();

    return Container();
  }
}