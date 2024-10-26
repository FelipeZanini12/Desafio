import 'dart:ffi';

import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

part 'task_store.g.dart';

class TaskStore = _TaskStore with _$TaskStore;

abstract class _TaskStore with Store {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @observable
  ObservableList<Task> taskList = ObservableList<Task>();

  @action
  Future<void> fetchAllTasks() async {
    try {
      // Busca todas as tarefas da coleção "tasks" no Firestore
      QuerySnapshot snapshot = await firestore.collection('tasks').get();

      // Mapeia cada documento da coleção para um objeto Task e adiciona à lista de tarefas
      taskList.clear();
      snapshot.docs.forEach((doc) {
        taskList.add(Task.fromMap(doc.data() as Map<String, dynamic>, doc.id));  // Agora passando o doc.id também
      });
    } catch (e) {
      print("Erro ao buscar todas as tarefas: $e");
    }
  }





  @action
  Future<void> fetchTasks(String userId) async {
    try {
      if (userId.isEmpty) {
        print("User ID is empty. Não foi possível buscar tarefas.");
        return;
      }

      // Pegue as tarefas iniciais com get()
      QuerySnapshot snapshot = await firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      taskList.clear();

      for (var doc in snapshot.docs) {
        taskList.add(Task.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }

      print("Tarefas carregadas: ${taskList.length}");

      // Escutar atualizações em tempo real
      firestore.collection('tasks')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
        taskList.clear();
        for (var doc in snapshot.docs) {
          taskList.add(Task.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }
        print("Atualizações de tarefas carregadas: ${taskList.length}");
      });

    } catch (e) {
      print("Erro ao buscar tarefas: $e");
    }
  }

  @action
  Future<void> addTask(Task task) async {
    try {
      var docRef = await firestore.collection('tasks').add(task.toMap());
      task.id = docRef.id;
      taskList.add(task);
    } catch (e) {
      print("Erro ao adicionar tarefa: $e");
    }
  }

  @action
  Future<void> deleteTask(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
      taskList.removeWhere((task) => task.id == taskId);  // Remove a tarefa da lista
    } catch (e) {
      print("Erro ao excluir tarefa: $e");
    }
  }

  @action
  Future<void> updateTask(Task task) async {
    try {
      await firestore.collection('tasks').doc(task.id).update(task.toMap());
      int index = taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        taskList[index] = task;  // Atualiza a tarefa na lista observável
      }
    } catch (e) {
      print("Erro ao atualizar tarefa: $e");
    }
  }
}
