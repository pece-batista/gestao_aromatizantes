import 'package:flutter/material.dart';
import 'telas/tela_estoque_produtos.dart';
import 'telas/tela_estoque_materia_prima.dart';
import 'telas/tela_producao.dart';
import 'telas/tela_receitas.dart';

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
    TelaReceitas(),
    TelaProducao(),
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
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science_outlined),
            label: 'Matéria-Prima',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Receitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering_outlined),
            label: 'Produção',
          ),
        ],
        currentIndex: _indiceAbaSelecionada,
        selectedItemColor: Colors.teal[600],
        onTap: _aoTocarNaAba,
      ),
    );
  }
}
