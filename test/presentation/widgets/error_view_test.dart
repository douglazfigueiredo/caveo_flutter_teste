import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caveo_flutter_teste/presentation/widgets/error_view.dart';

void main() {
  group('ErrorView Widget Tests', () {
    testWidgets('renders error message correctly', (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(message: errorMessage, onRetry: () {}),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays error icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(message: 'Error occurred', onRetry: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays retry button with correct text and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(message: 'Error occurred', onRetry: () {}),
          ),
        ),
      );

      expect(find.text('Tentar Novamente'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('calls onRetry callback when retry button is tapped', (
      WidgetTester tester,
    ) async {
      bool retryWasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Error occurred',
              onRetry: () {
                retryWasCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tentar Novamente'));
      await tester.pump();

      expect(retryWasCalled, isTrue);
    });

    testWidgets('displays all elements in correct layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(message: 'Error occurred', onRetry: () {}),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });
  });
}
