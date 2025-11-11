import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../domain/entities/product.dart';
import '../../shared/utils/result.dart';
import 'product_list_state.dart';

/// Notifier para gerenciar o estado da lista de produtos
class ProductListNotifier extends StateNotifier<ProductListState> {
  final Ref ref;

  /// Número de produtos a exibir por página
  static const int pageSize = 10;

  ProductListNotifier(this.ref) : super(const ProductListState());

  /// Carrega todos os produtos da API e exibe a primeira página
  Future<void> loadInitialProducts() async {
    // Evita múltiplas requisições simultâneas
    if (state.isLoading) return;

    // Define estado de carregamento
    state = state.copyWith(isLoading: true, error: null);

    // Obtém o comando do provider
    final command = ref.read(loadAllProductsCommandProvider);

    // Executa o comando
    final result = await command.execute();

    // Atualiza o estado baseado no resultado
    switch (result) {
      case Success<List<Product>>():
        final allProducts = result.data;
        final initialProducts = allProducts.take(pageSize).toList();

        state = state.copyWith(
          allProducts: allProducts,
          displayedProducts: initialProducts,
          isLoading: false,
          hasMore: allProducts.length > pageSize,
        );
        break;

      case Failure<List<Product>>():
        state = state.copyWith(isLoading: false, error: result.message);
        break;
    }
  }

  /// Carrega mais produtos da memória (paginação no cliente)
  Future<void> loadMoreProducts() async {
    // Evita carregar se já está carregando ou não há mais produtos
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    // Define estado de carregamento de paginação
    state = state.copyWith(isLoadingMore: true, error: null);

    // Simula delay de rede para melhor UX
    await Future.delayed(const Duration(milliseconds: 500));

    // Calcula quantos produtos já foram exibidos
    final currentCount = state.displayedProducts.length;

    // Pega o próximo chunk de produtos da memória
    final nextProducts = state.allProducts
        .skip(currentCount)
        .take(pageSize)
        .toList();

    // Adiciona os novos produtos aos já exibidos
    final newDisplayedProducts = [...state.displayedProducts, ...nextProducts];

    // Verifica se ainda há mais produtos para exibir
    final hasMore = newDisplayedProducts.length < state.allProducts.length;

    state = state.copyWith(
      displayedProducts: newDisplayedProducts,
      isLoadingMore: false,
      hasMore: hasMore,
    );
  }

  /// Reseta o estado para o inicial
  void reset() {
    state = const ProductListState();
  }
}
