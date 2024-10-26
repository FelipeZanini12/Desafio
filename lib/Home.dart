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

class _TaskListPageState extends State<TaskListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isCompleted = false;
  bool _isEditing = false;
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);  // Inicializando o TabController
    _loadAllTasks(); // Carrega todas as tarefas ao inicializar a tela
  }

  @override
  void dispose() {
    _tabController.dispose();  // Liberando o recurso do TabController ao encerrar a página
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAllTasks() async {
    await widget.taskStore.fetchAllTasks(); // Busca todas as tarefas no Firestore
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing && _editingTask != null) {
        // Atualizando a tarefa existente
        _editingTask!.title = _titleController.text;
        _editingTask!.description = _descriptionController.text;
        _editingTask!.dueDate = _dueDate ?? DateTime.now();
        _editingTask!.isCompleted = _isCompleted;
        widget.taskStore.updateTask(_editingTask!);
        _isEditing = false;
        _editingTask = null;
      } else {
        // Adicionando uma nova tarefa
        Task newTask = Task(
          id: '', // O ID será gerado no Firestore
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _dueDate ?? DateTime.now(),
          isCompleted: _isCompleted,
          userId: '', // Pode ser preenchido se necessário
        );
        widget.taskStore.addTask(newTask);
      }
      _clearForm(); // Limpa o formulário após salvar
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _isCompleted = false;
    _isEditing = false;
    _editingTask = null;
    setState(() {}); // Atualiza o estado da página
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

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Você tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela a exclusão
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma a exclusão
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Tarefa" : "Gerenciamento de Tarefas"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Formulário de Adicionar/Editar tarefa (agora em cima das Tabs)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o título da tarefa';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveTask, // Chama a função de salvar tarefa
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'Atualizar Tarefa' : 'Adicionar Tarefa',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tabs para separar as tarefas pendentes e concluídas
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Pendentes'),
              Tab(text: 'Concluídas'),
            ],
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                var pendingTasks = widget.taskStore.taskList
                    .where((task) => !task.isCompleted) // Filtra as tarefas pendentes
                    .toList();
                var completedTasks = widget.taskStore.taskList
                    .where((task) => task.isCompleted) // Filtra as tarefas concluídas
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTaskList(pendingTasks),  // Lista de Tarefas Pendentes
                    _buildTaskList(completedTasks), // Lista de Tarefas Concluídas
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text("Nenhuma tarefa encontrada."),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            // Exibe o diálogo de confirmação
            final confirm = await _showDeleteConfirmationDialog(context);
            if (confirm == true) {
              widget.taskStore.deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tarefa excluída')),
              );
              return true; // Confirma a exclusão
            }
            return false; // Cancela a exclusão
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                title: Text(
                  task.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(task.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editTask(task); // Função para editar a tarefa
                      },
                    ),
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                          // Atualiza localmente para refletir imediatamente na UI
                          task.isCompleted = value ?? false;
                        });

                        // Atualiza o Firestore em segundo plano
                        widget.taskStore.updateTask(task).catchError((error) {
                          // Em caso de erro, reverte a mudança no estado local
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao atualizar tarefa: $error')),
                          );
                        });
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
}
