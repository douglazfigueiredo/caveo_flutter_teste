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

  Future<List<ProductDto>> getProducts({
    required int limit,
    required int offset,
  }) async {
    final response = await dio.get(
      '/products',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
