import 'package:dio/dio.dart';
import '../../application/dtos/product_dto.dart';

class FakeStoreApiClient {
  final Dio dio;
  static const String baseUrl = 'https://fakestoreapi.com';

  FakeStoreApiClient(this.dio) {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Busca todos os produtos da API
  ///
  /// A API Fake Store não suporta paginação real. Ela retorna todos os
  /// produtos disponíveis (~20 produtos) em uma única requisição.
  Future<List<ProductDto>> getAllProducts() async {
    final response = await dio.get('/products');

    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
