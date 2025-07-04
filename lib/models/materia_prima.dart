class MateriaPrima {
  String nome;
  double quantidade; // Usamos double para permitir valores como 10.5g
  String unidade; // Ex: "ml", "g", "un"

  MateriaPrima({
    required this.nome,
    required this.quantidade,
    required this.unidade,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'quantidade': quantidade,
    'unidade': unidade,
  };

  factory MateriaPrima.fromJson(Map<String, dynamic> json) => MateriaPrima(
    nome: json['nome'],
    quantidade: json['quantidade'],
    unidade: json['unidade'],
  );
}
