import '../../domain/entities/product.dart';

/// Estado da lista de produtos
class ProductListState {
  /// Todos os produtos carregados da API (cache em memória)
  final List<Product> allProducts;

  /// Lista de produtos exibidos atualmente (paginação no cliente)
  final List<Product> displayedProducts;

  /// Indica se está carregando os produtos iniciais
  final bool isLoading;

  /// Indica se está carregando mais produtos (paginação)
  final bool isLoadingMore;

  /// Mensagem de erro, se houver
  final String? error;

  /// Indica se há mais produtos para carregar
  final bool hasMore;

  const ProductListState({
    this.allProducts = const [],
    this.displayedProducts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
  });

  /// Cria uma cópia do estado com os campos especificados atualizados
  ProductListState copyWith({
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
  }) {
    return ProductListState(
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Limpa o erro mantendo os outros campos
  ProductListState clearError() {
    return copyWith(error: null);
  }
}
