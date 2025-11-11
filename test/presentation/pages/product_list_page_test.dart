import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caveo_flutter_teste/presentation/pages/product_list_page.dart';
import 'package:caveo_flutter_teste/presentation/state/product_list_state.dart';
import 'package:caveo_flutter_teste/presentation/state/product_list_notifier.dart';
import 'package:caveo_flutter_teste/presentation/widgets/product_card.dart';
import 'package:caveo_flutter_teste/presentation/widgets/loading_indicator.dart';
import 'package:caveo_flutter_teste/presentation/widgets/error_view.dart';
import 'package:caveo_flutter_teste/domain/entities/product.dart';
import 'package:caveo_flutter_teste/domain/entities/rating.dart';
import 'package:caveo_flutter_teste/app/providers.dart';

void main() {
  group('ProductListPage Widget Tests', () {
    late List<Product> testProducts;

    setUp(() {
      testProducts = [
        const Product(
          id: 1,
          title: 'Product 1',
          price: 99.99,
          description: 'Description 1',
          category: 'category1',
          image: 'https://example.com/image1.jpg',
          rating: Rating(rate: 4.5, count: 120),
        ),
        const Product(
          id: 2,
          title: 'Product 2',
          price: 49.99,
          description: 'Description 2',
          category: 'category2',
          image: 'https://example.com/image2.jpg',
          rating: Rating(rate: 3.8, count: 80),
        ),
        const Product(
          id: 3,
          title: 'Product 3',
          price: 149.99,
          description: 'Description 3',
          category: 'category3',
          image: 'https://example.com/image3.jpg',
          rating: Rating(rate: 4.2, count: 200),
        ),
      ];
    });

    Widget createTestWidget(ProductListState state) {
      return ProviderScope(
        overrides: [
          productListProvider.overrideWith(
            (ref) => MockProductListNotifier(state),
          ),
        ],
        child: const MaterialApp(home: ProductListPage()),
      );
    }

    group('Renderização da lista', () {
      testWidgets('renderiza AppBar com título correto', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(products: testProducts);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.text('Produtos'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('renderiza lista de produtos corretamente', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(products: testProducts);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.byType(ProductCard), findsNWidgets(3));
        expect(find.text('Product 1'), findsOneWidget);
        expect(find.text('Product 2'), findsOneWidget);
        expect(find.text('Product 3'), findsOneWidget);
      });

      testWidgets('renderiza empty state quando não há produtos', (
        WidgetTester tester,
      ) async {
        const state = ProductListState(products: []);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.text('Nenhum produto disponível'), findsOneWidget);
        expect(find.byType(ProductCard), findsNothing);
      });

      testWidgets('usa ListView.builder para renderização', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(products: testProducts);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('Estados de loading', () {
      testWidgets('mostra LoadingIndicator quando isLoading é true', (
        WidgetTester tester,
      ) async {
        const state = ProductListState(isLoading: true);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.byType(LoadingIndicator), findsOneWidget);
        expect(find.byType(ProductCard), findsNothing);
      });

      testWidgets(
        'mostra loading indicator no final da lista quando isLoadingMore é true',
        (WidgetTester tester) async {
          final state = ProductListState(
            products: testProducts,
            isLoadingMore: true,
          );

          await tester.pumpWidget(createTestWidget(state));

          // Deve ter os produtos
          expect(find.byType(ProductCard), findsNWidgets(3));

          // Verifica que há um item extra na lista (o loading indicator)
          final listView = tester.widget<ListView>(find.byType(ListView));
          expect(
            listView.semanticChildCount,
            equals(4),
          ); // 3 produtos + 1 loading
        },
      );

      testWidgets('não mostra loading extra quando isLoadingMore é false', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(products: testProducts);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.byType(ProductCard), findsNWidgets(3));

        // Verifica que a lista tem apenas os 3 produtos
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.semanticChildCount, equals(3));
      });
    });

    group('Estados de erro', () {
      testWidgets('mostra ErrorView quando há erro e lista está vazia', (
        WidgetTester tester,
      ) async {
        const state = ProductListState(
          products: [],
          error: 'Erro ao carregar produtos',
        );

        await tester.pumpWidget(createTestWidget(state));

        expect(find.byType(ErrorView), findsOneWidget);
        expect(find.text('Erro ao carregar produtos'), findsOneWidget);
        expect(find.byType(ProductCard), findsNothing);
      });

      testWidgets('mostra produtos quando há erro mas lista não está vazia', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(
          products: testProducts,
          error: 'Erro ao carregar mais produtos',
        );

        await tester.pumpWidget(createTestWidget(state));
        await tester.pump();

        // Deve mostrar os produtos existentes
        expect(find.byType(ProductCard), findsNWidgets(3));
        expect(find.byType(ErrorView), findsNothing);
      });

      testWidgets('mostra SnackBar quando há erro durante paginação', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(
          products: testProducts,
          error: 'Erro ao carregar mais produtos',
        );

        await tester.pumpWidget(createTestWidget(state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Erro ao carregar mais produtos'), findsOneWidget);
        expect(find.text('Tentar Novamente'), findsOneWidget);
      });
    });

    group('Scroll infinito', () {
      testWidgets('renderiza produtos em uma lista scrollável', (
        WidgetTester tester,
      ) async {
        // Cria uma lista maior para testar scroll
        final manyProducts = List.generate(
          25,
          (index) => Product(
            id: index,
            title: 'Product $index',
            price: 99.99,
            description: 'Description $index',
            category: 'category',
            image: 'https://example.com/image.jpg',
            rating: const Rating(rate: 4.5, count: 100),
          ),
        );

        final state = ProductListState(products: manyProducts, hasMore: true);

        await tester.pumpWidget(createTestWidget(state));

        expect(find.byType(ProductCard), findsWidgets);
        // Verifica que pelo menos alguns produtos estão renderizados
        expect(find.text('Product 0'), findsOneWidget);
      });

      testWidgets('mostra loading indicator quando carregando mais produtos', (
        WidgetTester tester,
      ) async {
        final state = ProductListState(
          products: testProducts,
          isLoadingMore: true,
          hasMore: true,
        );

        await tester.pumpWidget(createTestWidget(state));

        // Deve mostrar os produtos
        expect(find.byType(ProductCard), findsNWidgets(3));

        // Verifica que há um item extra na lista (o loading indicator)
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(
          listView.semanticChildCount,
          equals(4),
        ); // 3 produtos + 1 loading
      });
    });
  });
}

/// Mock do ProductListNotifier para testes
class MockProductListNotifier extends ProductListNotifier {
  MockProductListNotifier(ProductListState initialState) : super(_MockRef()) {
    state = initialState;
  }

  @override
  Future<void> loadInitialProducts() async {
    // Mock implementation - não faz nada nos testes
  }

  @override
  Future<void> loadMoreProducts() async {
    // Mock implementation - não faz nada nos testes
  }

  @override
  void reset() {
    // Mock implementation - não faz nada nos testes
  }
}

/// Mock do Ref para testes
class _MockRef implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}
