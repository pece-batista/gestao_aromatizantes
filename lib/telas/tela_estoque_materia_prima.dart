import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/materia_prima.dart';

class TelaEstoqueMateriaPrima extends StatefulWidget {
  const TelaEstoqueMateriaPrima({super.key});

  @override
  State<TelaEstoqueMateriaPrima> createState() =>
      _TelaEstoqueMateriaPrimaState();
}

class _TelaEstoqueMateriaPrimaState extends State<TelaEstoqueMateriaPrima> {
  List<MateriaPrima> _materiasPrimas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  final String _chaveSalvar = 'materia_prima_estoque';

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dadosString = prefs.getString(_chaveSalvar);
    if (dadosString != null) {
      final List<dynamic> dadosJson = jsonDecode(dadosString);
      setState(() {
        _materiasPrimas = dadosJson
            .map((json) => MateriaPrima.fromJson(json))
            .toList();
      });
    } else {
      setState(() {
        _materiasPrimas = [
          MateriaPrima(
            nome: 'Álcool de Cereais',
            quantidade: 1000,
            unidade: 'ml',
          ),
          MateriaPrima(
            nome: 'Essência de Lavanda',
            quantidade: 100,
            unidade: 'ml',
          ),
          MateriaPrima(
            nome: 'Vidro 50ml com Tampa',
            quantidade: 50,
            unidade: 'un',
          ),
        ];
      });
    }
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final String dadosString = jsonEncode(
      _materiasPrimas.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_chaveSalvar, dadosString);
  }

  void _aumentarEstoque(int index) {
    setState(() {
      _materiasPrimas[index].quantidade++;
    });
    _salvarDados();
  }

  void _diminuirEstoque(int index) {
    if (_materiasPrimas[index].quantidade > 0) {
      setState(() {
        _materiasPrimas[index].quantidade--;
      });
      _salvarDados();
    }
  }

  Future<void> _mostrarDialogoAdicionar() async {
    final nomeController = TextEditingController();
    final qtdController = TextEditingController();
    final unidadeController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Matéria-Prima'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    hintText: 'Nome da matéria-prima',
                  ),
                ),
                TextField(
                  controller: qtdController,
                  decoration: const InputDecoration(hintText: 'Quantidade'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                TextField(
                  controller: unidadeController,
                  decoration: const InputDecoration(
                    hintText: 'Unidade (ml, g, un)',
                  ),
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
                final nome = nomeController.text;
                final quantidade = double.tryParse(qtdController.text);
                final unidade = unidadeController.text;
                if (nome.isNotEmpty &&
                    quantidade != null &&
                    unidade.isNotEmpty) {
                  setState(() {
                    _materiasPrimas.add(
                      MateriaPrima(
                        nome: nome,
                        quantidade: quantidade,
                        unidade: unidade,
                      ),
                    );
                  });
                  _salvarDados();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoEditarQuantidade(int index) async {
    final item = _materiasPrimas[index];
    final qtdController = TextEditingController(
      text: item.quantidade.toString(),
    );
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Quantidade de\n"${item.nome}"'),
          content: TextField(
            controller: qtdController,
            decoration: InputDecoration(
              hintText: 'Nova quantidade (${item.unidade})',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                final novaQuantidade = double.tryParse(qtdController.text);
                if (novaQuantidade != null) {
                  setState(() {
                    _materiasPrimas[index].quantidade = novaQuantidade;
                  });
                  _salvarDados();
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
      appBar: AppBar(title: const Text('Estoque de Matéria-Prima')),
      body: ListView.builder(
        itemCount: _materiasPrimas.length,
        itemBuilder: (context, index) {
          final item = _materiasPrimas[index];
          return Dismissible(
            key: Key(
              item.nome + DateTime.now().millisecondsSinceEpoch.toString(),
            ),
            onDismissed: (direction) {
              setState(() {
                _materiasPrimas.removeAt(index);
              });
              _salvarDados();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("${item.nome} removido")));
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
                  item.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Quantidade em estoque:'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _diminuirEstoque(index),
                    ),
                    InkWell(
                      onTap: () => _mostrarDialogoEditarQuantidade(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          '${item.quantidade.toStringAsFixed(1)} ${item.unidade}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
        onPressed: _mostrarDialogoAdicionar,
        tooltip: 'Adicionar Matéria-Prima',
        child: const Icon(Icons.add),
      ),
    );
  }
}
