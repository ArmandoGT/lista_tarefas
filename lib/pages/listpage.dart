import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/repositories/task_repository.dart';
import 'package:lista_tarefas/widgets/task_list_item.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController tasksController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = [];

  Task? deletedTask;
  int? deletedTaskPos;

  String? errorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    taskRepository.getTaskList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      // Campo de adicionar Tarefa
                      child: TextField(
                        controller: tasksController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex.: Estudar Flutter',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00b0c5),
                              width: 2,
                            )
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xff056671),
                          ),
                          errorText: errorText,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      // Botão de Adicionar
                      onPressed: () {
                        String text = tasksController.text;
                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'Não pode adicionar uma tarefa vazia';
                          });
                          return;
                        }

                        setState(() {
                          Task newTask = Task(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          tasks.add(newTask);
                          errorText = null;
                        });
                        tasksController.clear();
                        taskRepository.saveTaskList(tasks);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00b0c5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(10),
                      ),
                      child: Icon(Icons.add, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        TaskListItem(
                          task: task,
                          onDelete: () => onDelete(task),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${tasks.length} tarefas pendentes',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTasksConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00b0c5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(10),
                      ),
                      child: Text('Limpar tudo'),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Task task) {
    deletedTask = task;
    deletedTaskPos = tasks.indexOf(task);

    setState(() {
      {
        tasks.remove(task);
      }
    });

    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: <TextSpan>[
              const TextSpan(text: 'A tarefa '),
              TextSpan(
                text: task.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' foi removida!'),
            ],
          ),
        ),

        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00b0c5),
          onPressed: () {
            setState(() {
              tasks.insert(deletedTaskPos!, deletedTask!);
            });
            taskRepository.saveTaskList(tasks);
          },
        ),
      ),
    );
  }

  void showDeleteTasksConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Tem certeza que deseja limpar todas as suas tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xff00b0c5),
              foregroundColor: Colors.white,
            ),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTasks();
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xffc61717),
              foregroundColor: Colors.white,
            ),
            child: Text('Limpar tudo!'),
          ),
        ],
      ),
    );
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
    taskRepository.saveTaskList(tasks);
  }
}
