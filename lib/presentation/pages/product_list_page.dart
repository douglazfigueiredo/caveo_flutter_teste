import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_card.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  String? _previousError;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(productListProvider.notifier).loadMoreProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListProvider);

    // Mostra snackbar para erros durante paginação
    if (state.error != null &&
        state.displayedProducts.isNotEmpty &&
        state.error != _previousError) {
      _previousError = state.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              action: SnackBarAction(
                label: 'Tentar Novamente',
                onPressed: () {
                  ref.read(productListProvider.notifier).loadMoreProducts();
                },
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: _buildBody(state),
    );
  }

  Widget _buildBody(state) {
    // Se está carregando os produtos iniciais, mostra loading
    if (state.isLoading) {
      return const LoadingIndicator();
    }

    // Se houve erro e não há produtos, mostra erro
    if (state.error != null && state.displayedProducts.isEmpty) {
      return ErrorView(
        message: state.error!,
        onRetry: () {
          ref.read(productListProvider.notifier).loadInitialProducts();
        },
      );
    }

    // Se não há produtos, mostra empty state
    if (state.displayedProducts.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum produto disponível',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    // Mostra a lista de produtos
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.displayedProducts.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Se é o último item e está carregando mais, mostra loading indicator
        if (index >= state.displayedProducts.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Renderiza o card do produto
        return ProductCard(product: state.displayedProducts[index]);
      },
    );
  }
}
