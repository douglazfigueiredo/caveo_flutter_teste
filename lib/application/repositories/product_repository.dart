import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';

/// Interface de repositório para operações com produtos
abstract class ProductRepository {
  /// Busca todos os produtos da API
  ///
  /// A API Fake Store não suporta paginação, retornando todos os produtos
  /// disponíveis em uma única requisição.
  ///
  /// Retorna um Result contendo a lista de todos os produtos ou uma falha
  Future<Result<List<Product>>> getAllProducts();
}
