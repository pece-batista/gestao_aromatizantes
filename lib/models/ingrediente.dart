class Ingrediente {
  final String nomeItem;
  final double quantidadeUsada;
  final String unidade; // <-- CAMPO NOVO ADICIONADO

  Ingrediente({
    required this.nomeItem,
    required this.quantidadeUsada,
    required this.unidade, // <-- ADICIONADO AO CONSTRUTOR
  });

  Map<String, dynamic> toJson() => {
    'nomeItem': nomeItem,
    'quantidadeUsada': quantidadeUsada,
    'unidade': unidade, // <-- ADICIONADO AO JSON
  };

  factory Ingrediente.fromJson(Map<String, dynamic> json) => Ingrediente(
    nomeItem: json['nomeItem'],
    quantidadeUsada: json['quantidadeUsada'],
    unidade: json['unidade'] ?? 'g', // <-- ADICIONADO (com um valor padrão 'g')
  );
}
