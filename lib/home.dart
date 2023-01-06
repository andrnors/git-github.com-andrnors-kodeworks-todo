import 'package:flutter/material.dart';
import 'dart:math' as math;

class Todo {
  final int id;
  String text;

  Todo({
    required this.text,
    required this.id,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final todoController = TextEditingController();
  List<Todo> todos = [];

  void addTodo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        todos = [...todos, Todo(id: todos.length, text: todoController.text)];
      });
      todoController.clear();
    }
  }

  void editTodo(Todo todo) {
    setState(() {
      todo.text = todoController.text;
    });
    todoController.clear();
  }

  void deleteTodo(Todo todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  Widget _buildPopupDialog({required BuildContext context, int? index}) {
    if (index != null) {
      todoController.text = todos[index].text;
    }

    return AlertDialog(
      title: const Text('What todo'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textInputAction: TextInputAction.done,
              autofocus: true,
              controller: todoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "What's on your mind?"),
            )
          ]),
      actions: [
        OutlinedButton(
          onPressed: () {
            if (index == null) {
              addTodo();
            } else {
              editTodo(todos[index]);
            }
            Navigator.of(context).pop();
          },
          child: Text(index == null ? 'Add' : 'Save'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Todooss'),
        ),
        body: Center(
          child: SizedBox(
            width: width < 1000 ? width : 1000,
            child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1.0)),
                      child: ListTile(
                        title: Text(todos[index].text),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever),
                          onPressed: () => deleteTodo(todos[index]),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildPopupDialog(
                                context: context, index: index),
                          );
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => _buildPopupDialog(context: context));
          },
          tooltip: 'Increment',
          label: const Text('Add todo'),
        ));
  }
}
