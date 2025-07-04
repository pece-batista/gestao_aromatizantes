class MateriaPrima {
  String nome;
  double quantidade; 
  String unidade; 

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
