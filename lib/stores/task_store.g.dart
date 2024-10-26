// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskStore on _TaskStore, Store {
  late final _$taskListAtom =
      Atom(name: '_TaskStore.taskList', context: context);

  @override
  ObservableList<Task> get taskList {
    _$taskListAtom.reportRead();
    return super.taskList;
  }

  @override
  set taskList(ObservableList<Task> value) {
    _$taskListAtom.reportWrite(value, super.taskList, () {
      super.taskList = value;
    });
  }

  late final _$fetchTasksAsyncAction =
      AsyncAction('_TaskStore.fetchTasks', context: context);

  @override
  Future<void> fetchTasks(String userId) {
    return _$fetchTasksAsyncAction.run(() => super.fetchTasks(userId));
  }

  late final _$addTaskAsyncAction =
      AsyncAction('_TaskStore.addTask', context: context);

  @override
  Future<void> addTask(Task task) {
    return _$addTaskAsyncAction.run(() => super.addTask(task));
  }

  late final _$updateTaskAsyncAction =
      AsyncAction('_TaskStore.updateTask', context: context);

  @override
  Future<void> updateTask(Task task) {
    return _$updateTaskAsyncAction.run(() => super.updateTask(task));
  }

  late final _$deleteTaskAsyncAction =
      AsyncAction('_TaskStore.deleteTask', context: context);

  @override
  Future<void> deleteTask(String taskId) {
    return _$deleteTaskAsyncAction.run(() => super.deleteTask(taskId));
  }

  @override
  String toString() {
    return '''
taskList: ${taskList}
    ''';
  }
}
