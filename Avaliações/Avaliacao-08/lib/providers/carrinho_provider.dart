import 'package:flutter/material.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final Map<String, ItemCarrinho> _itens = {};

  Map<String, ItemCarrinho> get itens => {..._itens};

  int get totalItens {
    int total = 0;
    _itens.forEach((key, item) {
      total += item.quantidade;
    });
    return total;
  }

  double get valorTotal {
    double total = 0.0;
    _itens.forEach((key, item) {
      total += item.subtotal;
    });
    return total;
  }

  void adicionarProduto(Produto produto) {
    if (_itens.containsKey(produto.id)) {
      _itens[produto.id]!.quantidade += 1;
    } else {
      _itens[produto.id] = ItemCarrinho(produto: produto);
    }
    notifyListeners();
  }

  void removerUnidade(String produtoId) {
    if (!_itens.containsKey(produtoId)) return;

    if (_itens[produtoId]!.quantidade > 1) {
      _itens[produtoId]!.quantidade -= 1;
    } else {
      _itens.remove(produtoId);
    }
    notifyListeners();
  }

  void removerItemCompleto(String produtoId) {
    _itens.remove(produtoId);
    notifyListeners();
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}