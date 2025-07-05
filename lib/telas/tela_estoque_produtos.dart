import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produto.dart';
import '../models/ingrediente.dart';

class TelaEstoqueProdutos extends StatefulWidget {
  const TelaEstoqueProdutos({super.key});

  @override
  State<TelaEstoqueProdutos> createState() => _TelaEstoqueProdutosState();
}

class _TelaEstoqueProdutosState extends State<TelaEstoqueProdutos> {
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? produtosString = prefs.getString('produtos_estoque');
    if (produtosString != null) {
      final List<dynamic> produtosJson = jsonDecode(produtosString);
      setState(() {
        _produtos = produtosJson.map((json) => Produto.fromJson(json)).toList();
      });
    } else {
      setState(() {
        _produtos = [
          Produto(
            nome: 'Aromatizante de Lavanda 50ml',
            quantidade: 15,
            unidade: 'un',
            receita: [
              Ingrediente(
                nomeItem: 'Álcool de Cereais',
                quantidadeUsada: 40,
                unidade: 'ml',
              ),
              Ingrediente(
                nomeItem: 'Essência de Lavanda',
                quantidadeUsada: 10,
                unidade: 'ml',
              ),
              Ingrediente(
                nomeItem: 'Vidro 50ml com Tampa',
                quantidadeUsada: 1,
                unidade: 'un',
              ),
            ],
          ),
          Produto(
            nome: 'Aromatizante de Alecrim 50ml',
            quantidade: 8,
            unidade: 'un',
            receita: [],
          ),
        ];
      });
    }
  }

  Future<void> _salvarProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final String produtosString = jsonEncode(
      _produtos.map((p) => p.toJson()).toList(),
    );
    await prefs.setString('produtos_estoque', produtosString);
  }

  void _aumentarEstoque(int index) {
    setState(() {
      _produtos[index].quantidade++;
    });
    _salvarProdutos();
  }

  void _diminuirEstoque(int index) {
    if (_produtos[index].quantidade > 0) {
      setState(() {
        _produtos[index].quantidade--;
      });
      _salvarProdutos();
    }
  }

  Future<void> _mostrarDialogoAdicionarProduto() async {
    final nomeController = TextEditingController();
    final qtdController = TextEditingController();
    String unidadeSelecionada =
        'un'; // Valor inicial para o dropdown de unidade

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Novo Produto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do produto',
                  ),
                ),
                const SizedBox(height: 10),
                // Layout em linha para Quantidade e Unidade
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2, // Dá mais espaço para a quantidade
                      child: TextField(
                        controller: qtdController,
                        decoration: const InputDecoration(
                          labelText: 'Quantidade',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1, // Dá menos espaço para a unidade
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Un.'),
                        value: unidadeSelecionada,
                        items: ['un', 'ml', 'g', 'kg']
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            unidadeSelecionada = newValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                final String nome = nomeController.text;
                final int? quantidade = int.tryParse(qtdController.text);
                if (nome.isNotEmpty && quantidade != null) {
                  setState(() {
                    // Adiciona o produto com a unidade selecionada
                    _produtos.add(
                      Produto(
                        nome: nome,
                        quantidade: quantidade,
                        unidade: unidadeSelecionada,
                        receita: [],
                      ),
                    );
                  });
                  _salvarProdutos();
                  Navigator.of(context).pop();
                }
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
      appBar: AppBar(title: const Text('Estoque de Produtos')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Dismissible(
            key: Key(
              produto.nome + DateTime.now().millisecondsSinceEpoch.toString(),
            ),
            onDismissed: (direction) {
              setState(() {
                _produtos.removeAt(index);
              });
              _salvarProdutos();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${produto.nome} removido")),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  produto.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Quantidade em estoque:'),
                // Atualiza a exibição da quantidade para incluir a unidade
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _diminuirEstoque(index),
                    ),
                    Text(
                      '${produto.quantidade} ${produto.unidade}', // Mostra a unidade aqui
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _aumentarEstoque(index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionarProduto,
        tooltip: 'Adicionar Produto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
