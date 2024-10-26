import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';
import 'cadastro.dart';
import 'stores/task_store.dart'; // Importa o TaskStore para gerenciar as tarefas

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  void _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        _logarUsuario(email, senha);
      } else {
        setState(() => _mensagemErro = "Preencha a senha!");
      }
    } else {
      setState(() => _mensagemErro = "Preencha o E-mail corretamente!");
    }
  }

  void _logarUsuario(String email, String senha) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential =
      await auth.signInWithEmailAndPassword(email: email, password: senha);

      TaskStore taskStore = TaskStore();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskListPage(taskStore: taskStore),
        ),
      );
    } catch (e) {
      setState(() => _mensagemErro = "Erro ao autenticar usuário: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Image.asset("imagens/logo.png", width: 200, height: 150),
                ),
                _buildTextField(
                  "E-mail",
                  _controllerEmail,
                  TextInputType.emailAddress,
                ),
                _buildTextField(
                  "Senha",
                  _controllerSenha,
                  TextInputType.text,
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: _validarCampos,
                  child: Text("Entrar"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navegação para a tela de recuperação de senha
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RecuperarSenha()));
                  },
                  child: Text("Esqueceu a senha?"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Cadastro()));
                  },
                  child: Text("Não tem conta? Cadastre-se"),
                ),
                Text(
                  _mensagemErro,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget genérico para TextFields
  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }
}
