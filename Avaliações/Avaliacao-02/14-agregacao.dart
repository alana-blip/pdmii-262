import 'dart:convert';

// 14-agregacao.dart  
// Agregação e Composição

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  var dep1 = Dependente("Maria Letícia dos Santos");
  var dep2 = Dependente("João Matos");
  var dep3 = Dependente("Pedro Lucas Braga");

  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos funcionarios
  var func1 = Funcionario("Felícia dos Santos", [dep1]);
  var func2 = Funcionario("Ana Maria B.", [dep3]);
  var func3 = Funcionario("Francisco Juliano Matos", [dep2]);

  // 4. Criar uma lista de Funcionarios
  List<Funcionario> listaFuncionarios = [func1, func2, func3];

  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  var equipe = EquipeProjeto("Sistema EDP", listaFuncionarios);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  var equipeMap = {
    'nomeProjeto': equipe._nomeProjeto,
    'funcionarios': equipe._funcionarios.map((f) => {
      'nome': f._nome,
      'dependentes': f._dependentes.map((d) => {
        'nome': d._nome
      }).toList()
    }).toList()
  };

  print(JsonEncoder.withIndent('  ').convert(equipeMap));
}
