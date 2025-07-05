import 'package:flutter/material.dart';

class TelaProducao extends StatefulWidget {
  const TelaProducao({super.key});

  @override
  State<TelaProducao> createState() => _TelaProducaoState();
}

class _TelaProducaoState extends State<TelaProducao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Produção')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título da seção
            const Text(
              'O que você produziu hoje?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Menu para selecionar o produto (ainda não funcional)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Selecione o Produto Final',
                border: OutlineInputBorder(),
              ),
              items: const [], // Por enquanto, a lista está vazia
              onChanged: (String? newValue) {
                // Lógica para quando um item for selecionado
              },
            ),
            const SizedBox(height: 20),

            // Campo para digitar a quantidade produzida
            TextField(
              decoration: const InputDecoration(
                labelText: 'Quantidade Produzida',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // Botão para registrar a produção
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Registrar Produção'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Lógica final que vamos implementar em breve
              },
            ),
          ],
        ),
      ),
    );
  }
}
