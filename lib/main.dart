import 'package:flutter/material.dart';
import 'telas/tela_estoque_produtos.dart';
import 'telas/tela_estoque_materia_prima.dart';

void main() {
  runApp(const GestaoAromatizantesApp());
}

class GestaoAromatizantesApp extends StatelessWidget {
  const GestaoAromatizantesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Aromatizantes',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // A CORREÇÃO ESTÁ AQUI: a "home" é a TelaPrincipal
      home: const TelaPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indiceAbaSelecionada = 0;

  static const List<Widget> _telas = <Widget>[
    TelaEstoqueProdutos(),
    TelaEstoqueMateriaPrima(),
  ];

  void _aoTocarNaAba(int index) {
    setState(() {
      _indiceAbaSelecionada = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _telas.elementAt(_indiceAbaSelecionada)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science_outlined),
            label: 'Matéria-Prima',
          ),
        ],
        currentIndex: _indiceAbaSelecionada,
        selectedItemColor: Colors.teal[600],
        onTap: _aoTocarNaAba,
      ),
    );
  }
}
