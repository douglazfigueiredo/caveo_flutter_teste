import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';
import '../repositories/product_repository.dart';
import 'command.dart';

/// Command para carregar o primeiro lote de produtos
class LoadInitialProductsCommand implements Command<List<Product>> {
  final ProductRepository repository;

  /// Número de produtos a carregar inicialmente
  static const int initialLimit = 20;

  const LoadInitialProductsCommand(this.repository);

  @override
  Future<Result<List<Product>>> execute() async {
    return await repository.getProducts(limit: initialLimit, offset: 0);
  }
}
