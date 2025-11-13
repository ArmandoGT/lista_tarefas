import 'package:lista_tarefas/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const taskListkey = 'task_list';

class TaskRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Task>> getTaskList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(taskListkey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Task.fromJson(e)).toList();
  }



  void saveTaskList(List<Task> tasks) {
    final jsonString = json.encode(tasks);
    sharedPreferences.setString(('task_list'), jsonString);
  }
}
