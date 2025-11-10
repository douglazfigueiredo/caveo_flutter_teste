import 'package:caveo_flutter_teste/application/dtos/product_dto.dart';
import 'package:caveo_flutter_teste/application/dtos/rating_dto.dart';
import 'package:caveo_flutter_teste/domain/entities/product.dart';
import 'package:caveo_flutter_teste/infrastructure/api/fake_store_api_client.dart';
import 'package:caveo_flutter_teste/infrastructure/repositories/product_repository_impl.dart';
import 'package:caveo_flutter_teste/shared/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([FakeStoreApiClient])
void main() {
  late ProductRepositoryImpl repository;
  late MockFakeStoreApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockFakeStoreApiClient();
    repository = ProductRepositoryImpl(mockApiClient);
  });

  group('ProductRepositoryImpl', () {
    test(
      'deve retornar Success com lista de produtos quando API retorna sucesso',
      () async {
        // Arrange
        final productDtos = [
          ProductDto(
            id: 1,
            title: 'Test Product',
            price: 99.99,
            description: 'Test Description',
            category: 'Test Category',
            image: 'https://test.com/image.jpg',
            rating: const RatingDto(rate: 4.5, count: 100),
          ),
        ];

        when(
          mockApiClient.getProducts(limit: 20, offset: 0),
        ).thenAnswer((_) async => productDtos);

        // Act
        final result = await repository.getProducts(limit: 20, offset: 0);

        // Assert
        expect(result, isA<Success<List<Product>>>());
        final success = result as Success<List<Product>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.title, 'Test Product');
        verify(mockApiClient.getProducts(limit: 20, offset: 0)).called(1);
      },
    );

    test('deve retornar Failure quando ocorre timeout', () async {
      // Arrange
      when(mockApiClient.getProducts(limit: 20, offset: 0)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      final result = await repository.getProducts(limit: 20, offset: 0);

      // Assert
      expect(result, isA<Failure<List<Product>>>());
      final failure = result as Failure<List<Product>>;
      expect(failure.message, 'A requisição demorou muito. Tente novamente.');
    });

    test('deve retornar Failure quando não há conexão', () async {
      // Arrange
      when(mockApiClient.getProducts(limit: 20, offset: 0)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products'),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act
      final result = await repository.getProducts(limit: 20, offset: 0);

      // Assert
      expect(result, isA<Failure<List<Product>>>());
      final failure = result as Failure<List<Product>>;
      expect(
        failure.message,
        'Sem conexão com a internet. Verifique sua conexão.',
      );
    });

    test('deve retornar Failure quando servidor retorna erro 500', () async {
      // Arrange
      when(mockApiClient.getProducts(limit: 20, offset: 0)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/products'),
            statusCode: 500,
          ),
        ),
      );

      // Act
      final result = await repository.getProducts(limit: 20, offset: 0);

      // Assert
      expect(result, isA<Failure<List<Product>>>());
      final failure = result as Failure<List<Product>>;
      expect(failure.message, 'Erro no servidor. Tente novamente mais tarde.');
    });

    test('deve retornar Failure quando ocorre erro inesperado', () async {
      // Arrange
      when(
        mockApiClient.getProducts(limit: 20, offset: 0),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.getProducts(limit: 20, offset: 0);

      // Assert
      expect(result, isA<Failure<List<Product>>>());
      final failure = result as Failure<List<Product>>;
      expect(failure.message, 'Ocorreu um erro inesperado. Tente novamente.');
    });
  });
}
