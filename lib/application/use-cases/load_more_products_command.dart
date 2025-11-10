import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';
import '../repositories/product_repository.dart';
import 'command.dart';

/// Command para carregar mais produtos (paginação)
class LoadMoreProductsCommand implements Command<List<Product>> {
  final ProductRepository repository;
  final int currentOffset;

  /// Tamanho da página para paginação
  static const int pageSize = 20;

  const LoadMoreProductsCommand({
    required this.repository,
    required this.currentOffset,
  });

  @override
  Future<Result<List<Product>>> execute() async {
    return await repository.getProducts(limit: pageSize, offset: currentOffset);
  }
}
