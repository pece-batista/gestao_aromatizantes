import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestao_aromatizantes/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GestaoAromatizantesApp());

    // Verifica se o nosso app tem a barra de navegação com 4 itens.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    expect(find.byIcon(Icons.science_outlined), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
  });
}
