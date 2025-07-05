import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ingrediente.dart';
import '../models/receita.dart';

class TelaReceitas extends StatefulWidget {
  const TelaReceitas({super.key});

  @override
  State<TelaReceitas> createState() => _TelaReceitasState();
}

class _TelaReceitasState extends State<TelaReceitas> {
  List<Receita> _listaDeReceitas = [];
  final String _chaveSalvar = 'lista_de_receitas';

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dadosString = prefs.getString(_chaveSalvar);
    if (dadosString != null) {
      final List<dynamic> dadosJson = jsonDecode(dadosString);
      setState(() {
        _listaDeReceitas = dadosJson
            .map((json) => Receita.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _salvarReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    final String dadosString = jsonEncode(
      _listaDeReceitas.map((r) => r.toJson()).toList(),
    );
    await prefs.setString(_chaveSalvar, dadosString);
  }

  Future<void> _mostrarDialogoAdicionarReceita() async {
    final nomeReceitaController = TextEditingController();
    final itemResultanteNomeController = TextEditingController();
    final itemResultanteQtdController = TextEditingController();
    String unidadeResultanteSelecionada = 'un';
    bool itemResultanteEProdutoFinal = false;

    final ingredienteNomeController = TextEditingController();
    final ingredienteQtdController = TextEditingController();
    String unidadeIngredienteSelecionada =
        'g'; // Valor inicial para o novo dropdown

    List<Ingrediente> ingredientesDaReceita = [];

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Criar Nova Receita'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    // ... (campos de Informações da Receita e Item Produzido)
                    TextField(
                      controller: nomeReceitaController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Receita',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Item Produzido',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: itemResultanteNomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do item',
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: itemResultanteQtdController,
                            decoration: const InputDecoration(
                              labelText: 'Quantidade',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Un.'),
                            value: unidadeResultanteSelecionada,
                            items: ['un', 'ml', 'g', 'kg']
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setDialogState(
                              () => unidadeResultanteSelecionada = v!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: const Text("É um produto final?"),
                      value: itemResultanteEProdutoFinal,
                      onChanged: (v) => setDialogState(
                        () => itemResultanteEProdutoFinal = v ?? false,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 30, thickness: 1),
                    const Text(
                      'Ingredientes Necessários',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Mostra a lista de ingredientes já adicionados
                    ...ingredientesDaReceita.map(
                      (ing) => ListTile(
                        title: Text(ing.nomeItem),
                        trailing: Text('${ing.quantidadeUsada} ${ing.unidade}'),
                        dense: true,
                      ),
                    ),
                    // MUDANÇA AQUI: Mini-formulário de ingredientes agora com dropdown
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: ingredienteNomeController,
                            decoration: const InputDecoration(
                              labelText: 'Ingrediente',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: ingredienteQtdController,
                            decoration: const InputDecoration(labelText: 'Qtd'),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Un.'),
                            value: unidadeIngredienteSelecionada,
                            items: ['g', 'ml', 'un', 'kg']
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                unidadeIngredienteSelecionada = v;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Adicionar Ingrediente'),
                      onPressed: () {
                        final nome = ingredienteNomeController.text;
                        final qtd = double.tryParse(
                          ingredienteQtdController.text,
                        );
                        if (nome.isNotEmpty && qtd != null) {
                          setDialogState(() {
                            ingredientesDaReceita.add(
                              Ingrediente(
                                nomeItem: nome,
                                quantidadeUsada: qtd,
                                unidade: unidadeIngredienteSelecionada,
                              ),
                            );
                          });
                          ingredienteNomeController.clear();
                          ingredienteQtdController.clear();
                        }
                      },
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
                  child: const Text('Salvar Receita'),
                  onPressed: () {
                    final nomeReceita = nomeReceitaController.text;
                    final itemNome = itemResultanteNomeController.text;
                    final itemQtd = double.tryParse(
                      itemResultanteQtdController.text,
                    );
                    if (nomeReceita.isNotEmpty &&
                        itemNome.isNotEmpty &&
                        itemQtd != null &&
                        ingredientesDaReceita.isNotEmpty) {
                      final novaReceita = Receita(
                        nomeDaReceita: nomeReceita,
                        itemResultanteNome: itemNome,
                        itemResultanteQuantidade: itemQtd,
                        itemResultanteUnidade: unidadeResultanteSelecionada,
                        itemResultanteEProdutoFinal:
                            itemResultanteEProdutoFinal,
                        ingredientes: ingredientesDaReceita,
                      );
                      setState(() {
                        _listaDeReceitas.add(novaReceita);
                      });
                      _salvarReceitas();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Receitas')),
      body: _listaDeReceitas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma receita cadastrada.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _listaDeReceitas.length,
              itemBuilder: (context, index) {
                final receita = _listaDeReceitas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      receita.nomeDaReceita,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Produz: ${receita.itemResultanteQuantidade} ${receita.itemResultanteUnidade} de ${receita.itemResultanteNome}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionarReceita,
        tooltip: 'Adicionar Receita',
        child: const Icon(Icons.add),
      ),
    );
  }
}
