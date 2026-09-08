import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() async {
  // Define de forma assíncrona o caminho do banco de dados na raiz do projeto
  final caminhoBanco = p.join(Directory.current.path, 'alunos.db');
  print('Caminho do banco de dados: $caminhoBanco');

  Database? db;

  try {
    // 1) Se o banco de dados alunos.db não existir, ele cria automaticamente na raiz
    print('Abrindo/Criando o banco de dados...');
    db = sqlite3.open(caminhoBanco);

    // 2) Criação da tabela tb_alunos com tratamento de exceção
    try {
      print('Verificando/Criando a tabela tb_alunos...');
      db.execute('''
        CREATE TABLE IF NOT EXISTS tb_alunos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          idade INTEGER NOT NULL
        )
      ''');
      print('Tabela tb_alunos validada com sucesso.');
    } catch (e) {
      print('Erro ao criar a tabela tb_alunos: $e');
      return; // Interrompe a execução caso a tabela falhe
    }

    // 3) Incluir três alunos na tabela tb_alunos com tratamento de exceção
    try {
      // Verifica se a tabela está vazia para não duplicar dados a cada execução
      final resultadoCheck = db.select('SELECT COUNT(*) as total FROM tb_alunos');
      final totalAlunos = resultadoCheck.first['total'] as int;

      if (totalAlunos == 0) {
        print('\nInserindo 3 alunos na tabela...');
        
        // Preparando a query assíncrona/segura contra SQL Injection
        final stmt = db.prepare('INSERT INTO tb_alunos (nome, idade) VALUES (?, ?)');
        
        stmt.execute(['Alice Silva', 20]);
        stmt.execute(['Bruno Souza', 22]);
        stmt.execute(['Carla Dias', 19]);
        
        stmt.dispose(); // Libera a memória do statement
        print('3 alunos incluídos com sucesso!');
      } else {
        print('\nA tabela já possui alunos cadastrados.');
      }
    } catch (e) {
      print('Erro ao incluir os alunos na tabela: $e');
    }

    // 4) Listar o conteúdo da tabela tb_alunos com tratamento de exceção
    try {
      print('\n--- Listando o conteúdo da tabela tb_alunos ---');
      final ResultSet alunos = db.select('SELECT id, nome, idade FROM tb_alunos');

      if (alunos.isEmpty) {
        print('Nenhum aluno cadastrado no momento.');
      } else {
        for (final linha in alunos) {
          print('ID: ${linha['id']} | Nome: ${linha['nome']} | Idade: ${linha['idade']}');
        }
      }
      print('------------------------------------------------');
    } catch (e) {
      print('Erro ao listar os dados da tabela tb_alunos: $e');
    }

  } catch (e) {
    print('Erro crítico ao abrir o banco de dados: $e');
  } finally {
    // Garante que a conexão com o arquivo do banco seja encerrada com segurança
    if (db != null) {
      db.dispose();
      print('Conexão com o banco de dados fechada com segurança.');
    }
  }
}
