import 'package:dio/dio.dart';
import '../../application/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';
import '../api/fake_store_api_client.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FakeStoreApiClient apiClient;

  ProductRepositoryImpl(this.apiClient);

  @override
  Future<Result<List<Product>>> getAllProducts() async {
    try {
      final dtos = await apiClient.getAllProducts();
      final products = dtos.map((dto) => dto.toDomain()).toList();
      return Success(products);
    } on DioException catch (e) {
      return Failure(_handleDioError(e), e);
    } catch (e) {
      return Failure(
        'Ocorreu um erro inesperado. Tente novamente.',
        e as Exception?,
      );
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'A requisição demorou muito. Tente novamente.';

      case DioExceptionType.connectionError:
        return 'Sem conexão com a internet. Verifique sua conexão.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return 'Erro no servidor. Tente novamente mais tarde.';
        }
        return 'Erro ao buscar produtos. Tente novamente.';

      case DioExceptionType.cancel:
        return 'Requisição cancelada.';

      default:
        return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }
}
