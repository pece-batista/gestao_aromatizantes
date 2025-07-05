import 'ingrediente.dart';

class Produto {
  String nome;
  int quantidade;
  String unidade;
  List<Ingrediente> receita;

  Produto({
    required this.nome,
    required this.quantidade,
    required this.unidade,
    required this.receita,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'quantidade': quantidade,
    'unidade': unidade,
    'receita': receita.map((ingrediente) => ingrediente.toJson()).toList(),
  };

  factory Produto.fromJson(Map<String, dynamic> json) {
    var listaDeIngredientesJson = json['receita'] as List<dynamic>? ?? [];
    List<Ingrediente> receitaConvertida = listaDeIngredientesJson
        .map((i) => Ingrediente.fromJson(i))
        .toList();
    return Produto(
      nome: json['nome'],
      quantidade: json['quantidade'],
      unidade: json['unidade'] ?? 'un',
      receita: receitaConvertida,
    );
  }
}
