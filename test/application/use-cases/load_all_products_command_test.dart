import 'package:caveo_flutter_teste/application/repositories/product_repository.dart';
import 'package:caveo_flutter_teste/application/use-cases/load_all_products_command.dart';
import 'package:caveo_flutter_teste/domain/entities/product.dart';
import 'package:caveo_flutter_teste/domain/entities/rating.dart';
import 'package:caveo_flutter_teste/shared/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_all_products_command_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late LoadAllProductsCommand command;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    command = LoadAllProductsCommand(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<List<Product>>>(const Success([]));
  });

  group('LoadAllProductsCommand', () {
    test(
      'deve retornar Success com lista de produtos quando repository retorna sucesso',
      () async {
        // Arrange
        final products = [
          const Product(
            id: 1,
            title: 'Test Product',
            price: 99.99,
            description: 'Test Description',
            category: 'Test Category',
            image: 'https://test.com/image.jpg',
            rating: Rating(rate: 4.5, count: 100),
          ),
        ];

        when(
          mockRepository.getAllProducts(),
        ).thenAnswer((_) async => Success(products));

        // Act
        final result = await command.execute();

        // Assert
        expect(result, isA<Success<List<Product>>>());
        final success = result as Success<List<Product>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        verify(mockRepository.getAllProducts()).called(1);
      },
    );

    test('deve retornar Failure quando repository retorna erro', () async {
      // Arrange
      const errorMessage = 'Erro ao carregar produtos';
      when(
        mockRepository.getAllProducts(),
      ).thenAnswer((_) async => const Failure(errorMessage));

      // Act
      final result = await command.execute();

      // Assert
      expect(result, isA<Failure<List<Product>>>());
      final failure = result as Failure<List<Product>>;
      expect(failure.message, errorMessage);
    });

    test('deve buscar todos os produtos sem parâmetros de paginação', () async {
      // Arrange
      when(
        mockRepository.getAllProducts(),
      ).thenAnswer((_) async => const Success([]));

      // Act
      await command.execute();

      // Assert
      verify(mockRepository.getAllProducts()).called(1);
    });
  });
}
