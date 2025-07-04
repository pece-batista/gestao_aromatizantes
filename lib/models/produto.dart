class Produto {
  String nome;
  int quantidade;

  Produto({required this.nome, required this.quantidade});

  Map<String, dynamic> toJson() => {'nome': nome, 'quantidade': quantidade};

  factory Produto.fromJson(Map<String, dynamic> json) =>
      Produto(nome: json['nome'], quantidade: json['quantidade']);
}
