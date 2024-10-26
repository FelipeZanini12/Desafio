import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/task.dart';
import '../stores/task_store.dart';

class TaskListPage extends StatefulWidget {
  final TaskStore taskStore;

  TaskListPage({required this.taskStore});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isCompleted = false;
  bool _isEditing = false;
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    _loadAllTasks(); // Carrega todas as tarefas ao inicializar a tela
  }

  Future<void> _loadAllTasks() async {
    await widget.taskStore.fetchAllTasks(); // Busca todas as tarefas no Firestore
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing && _editingTask != null) {
        _editingTask!.title = _titleController.text;
        _editingTask!.description = _descriptionController.text;
        _editingTask!.dueDate = _dueDate ?? DateTime.now();
        _editingTask!.isCompleted = _isCompleted;
        widget.taskStore.updateTask(_editingTask!);
        _isEditing = false;
        _editingTask = null;
      } else {
        Task newTask = Task(
          id: '', // O ID será gerado no Firestore
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _dueDate ?? DateTime.now(),
          isCompleted: _isCompleted,
          userId: '', // Você pode deixar em branco se não estiver usando userId
        );
        widget.taskStore.addTask(newTask);
      }
      _clearForm();
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _isCompleted = false;
    _isEditing = false;
    _editingTask = null;
    setState(() {});
  }

  void _editTask(Task task) {
    setState(() {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _isCompleted = task.isCompleted;
      _editingTask = task;
      _isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Tarefa" : "Gerenciamento de Tarefas"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título da Tarefa',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o título da tarefa';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'Atualizar Tarefa' : 'Adicionar Tarefa',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Observer(
                builder: (_) {
                  if (widget.taskStore.taskList.isEmpty) {
                    return Center(child: Text("Nenhuma tarefa encontrada."));
                  } else {
                    return ListView.builder(
                      itemCount: widget.taskStore.taskList.length,
                      itemBuilder: (context, index) {
                        final task = widget.taskStore.taskList[index];
                        return Dismissible(
                          key: Key(task.id),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            widget.taskStore.deleteTask(task.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tarefa excluída')),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(task.description),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        _editTask(task); // Função para editar a tarefa
                                      },
                                    ),
                                    Checkbox(
                                      value: task.isCompleted,
                                      onChanged: (bool? value) {
                                        task.isCompleted = value ?? false;
                                        widget.taskStore.updateTask(task); // Atualiza a tarefa
                                      },
                                      activeColor: Colors.blue,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _editTask(task); // Função para editar a tarefa
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
