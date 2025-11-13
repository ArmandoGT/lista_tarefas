import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key, required this.task, required this.onDelete});

  final Task task;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.18,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: const Color(0xFFC61717),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yy - HH:mm').format(task.dateTime),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                task.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
