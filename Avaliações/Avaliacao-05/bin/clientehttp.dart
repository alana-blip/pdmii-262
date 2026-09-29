import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final url = Uri.parse('http://localhost:8080/api/alunos');
  final client = HttpClient();

  try {
    final request = await client.getUrl(url);
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      final List<dynamic> dadosAlunos = jsonResponse['dados'];

      const wId = 4;
      const wNome = 15;
      const wDisc = 25;
      const wMedia = 8;
      const wFaltas = 8;

      print(
        '${'ID'.padRight(wId)} '
        '${'NOME'.padRight(wNome)} '
        '${'DISCIPLINA'.padRight(wDisc)} '
        '${'MEDIA'.padRight(wMedia)} '
        '${'FALTAS'.padRight(wFaltas)} '
        'MENSAGEM',
      );
      print('-' * 80);

      for (var item in dadosAlunos) {
        final id = item['id'].toString();
        final nome = item['nome'].toString();
        final disciplina = item['disciplina'].toString();
        final media = (item['media'] as num).toDouble().toStringAsFixed(1);
        final faltas = item['faltas'].toString();

        String mensagem = '';
        final intFaltas = item['faltas'] as int;
        final doubleMedia = (item['media'] as num).toDouble();

        if (intFaltas > 20) {
          mensagem = 'Reprovado por Faltas';
        } else if (doubleMedia < 6.0) {
          mensagem = 'Reprovado';
        } else {
          mensagem = 'Aprovado';
        }

        print(
          '${id.padRight(wId)} '
          '${nome.padRight(wNome)} '
          '${disciplina.padRight(wDisc)} '
          '${media.padRight(wMedia)} '
          '${faltas.padRight(wFaltas)} '
          '$mensagem',
        );
      }
    } else {
      print('Erro no servidor: Código ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao conectar no servidor web: $e');
  } finally {
    client.close();
  }
}