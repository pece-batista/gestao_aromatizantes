import 'ingrediente.dart';

class Receita {
  String nomeDaReceita;
  String itemResultanteNome; // O nome do item que esta receita produz
  double itemResultanteQuantidade; // A quantidade que ela produz
  String itemResultanteUnidade; // A unidade (ml, g, un)
  bool
  itemResultanteEProdutoFinal; // É um produto final ou um item intermediário?
  List<Ingrediente> ingredientes; // A lista de ingredientes que ela consome

  Receita({
    required this.nomeDaReceita,
    required this.itemResultanteNome,
    required this.itemResultanteQuantidade,
    required this.itemResultanteUnidade,
    required this.itemResultanteEProdutoFinal,
    required this.ingredientes,
  });

  // Métodos para salvar e carregar os dados
  Map<String, dynamic> toJson() => {
    'nomeDaReceita': nomeDaReceita,
    'itemResultanteNome': itemResultanteNome,
    'itemResultanteQuantidade': itemResultanteQuantidade,
    'itemResultanteUnidade': itemResultanteUnidade,
    'itemResultanteEProdutoFinal': itemResultanteEProdutoFinal,
    'ingredientes': ingredientes.map((i) => i.toJson()).toList(),
  };

  factory Receita.fromJson(Map<String, dynamic> json) {
    var ingredientesJson = json['ingredientes'] as List<dynamic>? ?? [];
    List<Ingrediente> ingredientesConvertidos = ingredientesJson
        .map((i) => Ingrediente.fromJson(i))
        .toList();

    return Receita(
      nomeDaReceita: json['nomeDaReceita'],
      itemResultanteNome: json['itemResultanteNome'],
      itemResultanteQuantidade: json['itemResultanteQuantidade'],
      itemResultanteUnidade: json['itemResultanteUnidade'],
      itemResultanteEProdutoFinal: json['itemResultanteEProdutoFinal'],
      ingredientes: ingredientesConvertidos,
    );
  }
}
