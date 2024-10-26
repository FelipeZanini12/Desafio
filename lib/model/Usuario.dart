class Usuario {
  String _nome = '';
  String _email = '';
  String _senha = '';

  Usuario();

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
    };
  }

  String get senha => _senha;
  set senha(String value) => _senha = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get nome => _nome;
  set nome(String value) => _nome = value;
}
