import '../entities/product.dart';

abstract class LoadProductsUseCase {
  Future<List<Product>> execute({required int limit, required int offset});
}
