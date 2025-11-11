import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caveo_flutter_teste/presentation/widgets/product_card.dart';
import 'package:caveo_flutter_teste/domain/entities/product.dart';
import 'package:caveo_flutter_teste/domain/entities/rating.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Product testProduct;

    setUp(() {
      testProduct = const Product(
        id: 1,
        title: 'Test Product Title',
        price: 99.99,
        description: 'Test description',
        category: 'test category',
        image: 'https://example.com/image.jpg',
        rating: Rating(rate: 4.5, count: 120),
      );
    });

    testWidgets('renders product title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      expect(find.text('Test Product Title'), findsOneWidget);
    });

    testWidgets('renders product price correctly formatted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      expect(find.textContaining('R\$'), findsOneWidget);
      expect(find.textContaining('99,99'), findsOneWidget);
    });

    testWidgets('renders product rating correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      expect(find.text('4.5 (120)'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('displays Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('truncates long title with ellipsis', (
      WidgetTester tester,
    ) async {
      final longTitleProduct = Product(
        id: 2,
        title:
            'This is a very long product title that should be truncated with ellipsis after two lines',
        price: 49.99,
        description: 'Test description',
        category: 'test category',
        image: 'https://example.com/image.jpg',
        rating: const Rating(rate: 3.8, count: 50),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: longTitleProduct)),
        ),
      );

      final titleWidget = tester.widget<Text>(
        find.text(longTitleProduct.title),
      );

      expect(titleWidget.maxLines, equals(2));
      expect(titleWidget.overflow, equals(TextOverflow.ellipsis));
    });
  });
}
