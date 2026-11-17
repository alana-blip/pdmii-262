import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produto.dart';
import '../providers/carrinho_provider.dart';
import 'carrinho_screen.dart';

class CatalogoScreen extends StatelessWidget {
  CatalogoScreen({super.key});

  final List<Produto> produtosDisponiveis = [
    Produto(id: '1', nome: 'Teclado Mecânico', preco: 350.00),
    Produto(id: '2', nome: 'Mouse Sem Fio', preco: 180.50),
    Produto(id: '3', nome: 'Monitor 24 Polegadas', preco: 890.00),
    Produto(id: '4', nome: 'Headset Gamer', preco: 240.00),
    Produto(id: '5', nome: 'Webcam Full HD', preco: 210.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Tech'),
        actions: [
          Consumer<CarrinhoProvider>(
            builder: (context, carrinho, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarrinhoScreen(),
                        ),
                      );
                    },
                  ),
                  if (carrinho.totalItens > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${carrinho.totalItens}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: produtosDisponiveis.length,
        itemBuilder: (context, index) {
          final produto = produtosDisponiveis[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(produto.nome),
              subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              trailing: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Adicionar'),
                onPressed: () {
                  context.read<CarrinhoProvider>().adicionarProduto(produto);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${produto.nome} adicionado ao carrinho!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
