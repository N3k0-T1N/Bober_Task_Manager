import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../model/task_model.dart';
import '/feature/auth/cubit/auth_cubit.dart';
import '/feature/auth/cubit/auth_state.dart';
import '/feature/auth/page/login.dart';
import '/feature/task/cubit/task_cubit.dart';
import '/feature/task/cubit/task_state.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthorized) {
          context.go(LoginPage.route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 184, 134, 11),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Мои задачи',
            style: TextStyle(color: Colors.black, fontSize: 20 * textScaleFactor),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              tooltip: 'Добавить задачу',
              onPressed: () => _showAddTaskDialog(context, textScaleFactor),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              tooltip: 'Настройки',
              onPressed: () {
                context.go('/settings');
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TasksLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    return _TaskCard(task: state.tasks[index]);
                  },
                );
              } else if (state is TasksError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ошибка: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<TasksCubit>().loadTasks(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('Нет задач'));
            },
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, double textScaleFactor) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Новая задача',
          style: TextStyle(color: Colors.black, fontSize: 18 * textScaleFactor),
        ),
        backgroundColor: const Color.fromARGB(255, 184, 134, 11),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: titleController,
              labelText: 'Название',
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descriptionController,
              labelText: 'Описание',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<TasksCubit>().addTask(
                      titleController.text,
                      descriptionController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.black),
      maxLines: maxLines,
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.brown,
          width: 2,
        ),
      ),
      color: const Color.fromARGB(255, 184, 134, 11),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (task.isCompleted)
              const Text(
                'Выполнено!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        subtitle: Text(
          task.description,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        leading: Tooltip(
          message: 'Отметить как выполнено',
          child: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              context.read<TasksCubit>().toggleTaskCompletion(task);
            },
          ),
        ),
        trailing: Tooltip(
          message: 'Удалить задачу',
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              context.read<TasksCubit>().deleteTask(task.id);
            },
          ),
        ),
      ),
    );
  }
}
