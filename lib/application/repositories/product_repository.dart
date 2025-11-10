import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';

/// Interface de repositório para operações com produtos
abstract class ProductRepository {
  /// Busca produtos da API com paginação
  ///
  /// [limit] - Número máximo de produtos a retornar
  /// [offset] - Número de produtos a pular (para paginação)
  ///
  /// Retorna um Result contendo a lista de produtos ou uma falha
  Future<Result<List<Product>>> getProducts({
    required int limit,
    required int offset,
  });
}
