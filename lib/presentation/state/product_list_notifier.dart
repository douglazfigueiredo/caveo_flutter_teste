import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../application/use-cases/load_initial_products_command.dart';
import '../../application/use-cases/load_more_products_command.dart';
import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';
import 'product_list_state.dart';

/// Notifier para gerenciar o estado da lista de produtos
class ProductListNotifier extends StateNotifier<ProductListState> {
  final Ref ref;

  ProductListNotifier(this.ref) : super(const ProductListState());

  /// Carrega os produtos iniciais
  Future<void> loadInitialProducts() async {
    // Evita múltiplas requisições simultâneas
    if (state.isLoading) return;

    // Define estado de carregamento
    state = state.copyWith(isLoading: true, error: null);

    // Obtém o comando do provider
    final command = ref.read(loadInitialProductsCommandProvider);

    // Executa o comando
    final result = await command.execute();

    // Atualiza o estado baseado no resultado
    switch (result) {
      case Success<List<Product>>():
        state = state.copyWith(
          displayedProducts: result.data,
          isLoading: false,
          hasMore:
              result.data.length >= LoadInitialProductsCommand.initialLimit,
        );
        break;

      case Failure<List<Product>>():
        state = state.copyWith(isLoading: false, error: result.message);
        break;
    }
  }

  /// Carrega mais produtos (paginação)
  Future<void> loadMoreProducts() async {
    // Evita carregar se já está carregando ou não há mais produtos
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    // Define estado de carregamento de paginação
    state = state.copyWith(isLoadingMore: true, error: null);

    // Calcula o offset baseado no número de produtos já carregados
    final currentOffset = state.displayedProducts.length;

    // Obtém o comando do provider com o offset atual
    final command = ref.read(loadMoreProductsCommandProvider(currentOffset));

    // Executa o comando
    final result = await command.execute();

    // Atualiza o estado baseado no resultado
    switch (result) {
      case Success<List<Product>>():
        final newProducts = result.data;

        // Se retornou menos produtos que o tamanho da página, não há mais produtos
        final hasMore = newProducts.length >= LoadMoreProductsCommand.pageSize;

        state = state.copyWith(
          displayedProducts: [...state.displayedProducts, ...newProducts],
          isLoadingMore: false,
          hasMore: hasMore,
        );
        break;

      case Failure<List<Product>>():
        state = state.copyWith(isLoadingMore: false, error: result.message);
        break;
    }
  }

  /// Reseta o estado para o inicial
  void reset() {
    state = const ProductListState();
  }
}
