import 'package:caveo_flutter_teste/application/repositories/product_repository.dart';
import 'package:caveo_flutter_teste/application/use-cases/load_more_products_command.dart';
import 'package:caveo_flutter_teste/domain/entities/product.dart';
import 'package:caveo_flutter_teste/domain/entities/rating.dart';
import 'package:caveo_flutter_teste/shared/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_more_products_command_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late LoadMoreProductsCommand command;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  setUpAll(() {
    provideDummy<Result<List<Product>>>(const Success([]));
  });

  group('LoadMoreProductsCommand', () {
    test(
      'deve retornar Success com lista de produtos quando repository retorna sucesso',
      () async {
        // Arrange
        const offset = 20;
        command = LoadMoreProductsCommand(
          repository: mockRepository,
          currentOffset: offset,
        );

        final products = [
          const Product(
            id: 21,
            title: 'Test Product 21',
            price: 149.99,
            description: 'Test Description',
            category: 'Test Category',
            image: 'https://test.com/image.jpg',
            rating: Rating(rate: 4.0, count: 50),
          ),
        ];

        when(
          mockRepository.getProducts(
            limit: LoadMoreProductsCommand.pageSize,
            offset: offset,
          ),
        ).thenAnswer((_) async => Success(products));

        // Act
        final result = await command.execute();

        // Assert
        expect(result, isA<Success<List<Product>>>());
        final success = result as Success<List<Product>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 21);
        verify(
          mockRepository.getProducts(
            limit: LoadMoreProductsCommand.pageSize,
            offset: offset,
          ),
        ).called(1);
      },
    );

    test('deve retornar Failure quando repository retorna erro', () async {
      // Arrange
      const offset = 40;
      command = LoadMoreProductsCommand(
        repository: mockRepository,
        currentOffset: offset,
      );

      const errorMessage = 'Erro ao carregar mais produtos';
      when(
        mockRepository.getProducts(
          limit: LoadMoreProductsCommand.pageSize,
          offset: offset,
        ),
      ).thenAnswer((_) async => const Failure(errorMessage));

      // Act
      final result = await command.execute();

      // Assert
      expect(result, isA<Failure<List<Product>>>());
      final failure = result as Failure<List<Product>>;
      expect(failure.message, errorMessage);
    });

    test('deve usar offset correto passado no construtor', () async {
      // Arrange
      const offset = 60;
      command = LoadMoreProductsCommand(
        repository: mockRepository,
        currentOffset: offset,
      );

      when(
        mockRepository.getProducts(
          limit: LoadMoreProductsCommand.pageSize,
          offset: offset,
        ),
      ).thenAnswer((_) async => const Success([]));

      // Act
      await command.execute();

      // Assert
      verify(mockRepository.getProducts(limit: 20, offset: 60)).called(1);
    });

    test('deve usar pageSize de 20 produtos', () async {
      // Arrange
      const offset = 0;
      command = LoadMoreProductsCommand(
        repository: mockRepository,
        currentOffset: offset,
      );

      when(
        mockRepository.getProducts(
          limit: LoadMoreProductsCommand.pageSize,
          offset: offset,
        ),
      ).thenAnswer((_) async => const Success([]));

      // Act
      await command.execute();

      // Assert
      verify(mockRepository.getProducts(limit: 20, offset: 0)).called(1);
    });
  });
}
