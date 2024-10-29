# desafio

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Gerenciador de Tarefas - Flutter
Este projeto faz parte do Desafio Flutter, onde o objetivo é desenvolver um aplicativo de gerenciamento de tarefas. O app foi desenvolvido utilizando Flutter e Firebase para fornecer uma experiência moderna e intuitiva, permitindo aos usuários gerenciar suas tarefas com facilidade e eficiência.

🎯 Objetivo do Projeto
O Gerenciador de Tarefas permite que os usuários possam:

Cadastrar e logar com autenticação por e-mail e senha.
Adicionar, editar, marcar como concluída ou excluir tarefas.
Visualizar tarefas separadas em listas de pendentes e concluídas.
Recuperar senha via e-mail caso o usuário a esqueça.
Sincronizar tarefas em tempo real com o Firebase Firestore.
🛠 Tecnologias Utilizadas
Flutter: Framework para o desenvolvimento de interfaces nativas para Android e iOS.
Firebase Authentication: Para cadastro e login de usuários.
Firebase Firestore: Banco de dados em tempo real para armazenamento de tarefas.
MobX: Biblioteca para gerenciamento de estado reativo.
Dart: Linguagem de programação utilizada pelo Flutter.
🔧 Configuração do Projeto
Pré-requisitos
Antes de começar, certifique-se de ter instalado:

Flutter SDK: Guia de instalação do Flutter
Conta no Firebase: Console Firebase

Claro! Vou criar uma versão de README.md focada no que o desafio Flutter pediu, com base nas funcionalidades e requisitos do seu projeto.

📝 Gerenciador de Tarefas - Flutter
Este projeto faz parte do Desafio Flutter, onde o objetivo é desenvolver um aplicativo de gerenciamento de tarefas. O app foi desenvolvido utilizando Flutter e Firebase para fornecer uma experiência moderna e intuitiva, permitindo aos usuários gerenciar suas tarefas com facilidade e eficiência.

🎯 Objetivo do Projeto
O Gerenciador de Tarefas permite que os usuários possam:

Cadastrar e logar com autenticação por e-mail e senha.
Adicionar, editar, marcar como concluída ou excluir tarefas.
Visualizar tarefas separadas em listas de pendentes e concluídas.
Recuperar senha via e-mail caso o usuário a esqueça.
Sincronizar tarefas em tempo real com o Firebase Firestore.
🛠 Tecnologias Utilizadas
Flutter: Framework para o desenvolvimento de interfaces nativas para Android e iOS.
Firebase Authentication: Para cadastro e login de usuários.
Firebase Firestore: Banco de dados em tempo real para armazenamento de tarefas.
MobX: Biblioteca para gerenciamento de estado reativo.
Dart: Linguagem de programação utilizada pelo Flutter.
🔧 Configuração do Projeto
Pré-requisitos
Antes de começar, certifique-se de ter instalado:

Flutter SDK: Guia de instalação do Flutter
Conta no Firebase: Console Firebase
Passos para Configurar
Clone o Repositório

No terminal, clone o repositório do projeto:

bash
Copiar código
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
Instale as Dependências

Rode o comando abaixo para instalar as dependências do Flutter:

bash
Copiar código
flutter pub get
Configure o Firebase

Crie um novo projeto no Firebase Console.
Habilite a autenticação por e-mail/senha.
Configure o Firestore com um banco de dados em modo de produção ou teste.
Baixe o arquivo de configuração:
Para Android: google-services.json.
Para iOS: GoogleService-Info.plist.
Adicione o arquivo na pasta do seu projeto (conforme a documentação oficial do Firebase).
Rodar o App

Finalmente, rode o app:

bash
Copiar código
flutter run
📱 Funcionalidades
🔐 Autenticação de Usuário
Cadastro e Login: O usuário pode se cadastrar e fazer login usando e-mail e senha.
Recuperação de Senha: Caso o usuário esqueça a senha, ele pode solicitar um e-mail de redefinição.
✅ Gerenciamento de Tarefas
Adicionar Tarefas: O usuário pode criar uma nova tarefa com título e descrição.
Editar Tarefas: Tarefas podem ser editadas diretamente.
Excluir Tarefas: Tarefas podem ser excluídas com confirmação.
Marcar Tarefas como Concluídas: O usuário pode marcar as tarefas como pendentes ou concluídas usando um checkbox.
Sincronização em Tempo Real: As tarefas são sincronizadas em tempo real com o Firestore, permitindo que o usuário veja as atualizações instantaneamente.
📅 Visualização por Abas
Pendentes: Tarefas que ainda não foram concluídas.
Concluídas: Tarefas que já foram finalizadas pelo usuário.
🔧 Arquitetura
O projeto segue o padrão MVVM (Model-View-ViewModel), utilizando o MobX para gerenciamento de estado, separando a lógica da interface para manter o código modular e fácil de manter.

Principais Componentes:
Models: Definem as estruturas de dados e as regras de negócio (por exemplo, Task).
Views: Responsáveis por renderizar a interface e capturar a interação do usuário (por exemplo, TaskListPage).
ViewModels: Implementados com MobX no arquivo task_store.dart, gerenciam o estado das tarefas e a comunicação com o Firestore.
🎯 Requisitos do Desafio Atendidos
Autenticação de Usuários: Implementado utilizando Firebase Authentication.
Gerenciamento de Tarefas: O app permite adicionar, editar, excluir e marcar tarefas como concluídas.
Sincronização em Tempo Real: Implementado utilizando Firebase Firestore.
Arquitetura MVVM: Implementada com Flutter e MobX para gerenciamento de estado.
Testes Unitários e de Widget: Implementados para garantir a estabilidade do código.
🚀 Próximos Passos
Notificações: Implementar notificações para lembrar o usuário sobre tarefas pendentes.
Testes de Integração: Expandir a cobertura de testes, incluindo testes de integração de ponta a ponta.
Melhorias na UI: Refinar a interface com animações e transições mais fluidas.

