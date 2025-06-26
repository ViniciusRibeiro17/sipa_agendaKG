import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _getTasksCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não autenticado.");
    }
    return _firestore.collection('users').doc(user.uid).collection('tasks');
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _getTasksCollection().add(task.toMap());
    } catch (e) {
      print("Erro ao adicionar tarefa: $e");
      rethrow;
    }
  }

  Stream<List<TaskModel>> getTasks() {
    return _getTasksCollection().orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _getTasksCollection().doc(task.id).update(task.toMap());
    } catch (e) {
      print("Erro ao atualizar tarefa: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _getTasksCollection().doc(taskId).delete();
    } catch (e) {
      print("Erro ao excluir tarefa: $e");
      rethrow;
    }
  }
}
