import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/task_model.dart';

class TasksRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TasksRepository(this._firestore, this._auth);

  String get _userId => _auth.currentUser!.uid;

  Stream<List<TaskModel>> getTasks() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> addTask(String title, String description) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .add({
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateTask(TaskModel task) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}