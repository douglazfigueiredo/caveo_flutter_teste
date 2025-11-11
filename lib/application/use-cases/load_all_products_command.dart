import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';
import '../repositories/product_repository.dart';
import 'command.dart';

/// Command para carregar todos os produtos da API
///
/// A API Fake Store não suporta paginação, então este comando
/// busca todos os produtos disponíveis em uma única requisição.
class LoadAllProductsCommand implements Command<List<Product>> {
  final ProductRepository repository;

  const LoadAllProductsCommand(this.repository);

  @override
  Future<Result<List<Product>>> execute() async {
    return await repository.getAllProducts();
  }
}
