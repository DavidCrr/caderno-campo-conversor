import 'package:flutter_test/flutter_test.dart';
import 'package:caderno_campo_conversor/main.dart';

void main() {
  testWidgets('Carrega tela do Conversor da Roça', (WidgetTester tester) async {
    await tester.pumpWidget(const ConversorRocaApp());
    expect(find.text('Conversor da Roça'), findsOneWidget);
  });
}
