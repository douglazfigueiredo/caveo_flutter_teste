# Caveo Flutter Teste — Lista de Produtos

Aplicativo Flutter que consome a Fake Store API para listar produtos com paginação infinita no cliente, seguindo uma arquitetura enxuta baseada em Command Pattern, Riverpod para injeção/estado e Dio para HTTP.

## Sumário
- Visão Geral
- Tecnologias Utilizadas
- Arquitetura
- Funcionalidades
- Estrutura do Projeto
- Como Executar
- Testes
- API e Dados
- Tratamento de Erros e Estados
- Próximos Passos

## Visão Geral
Ao abrir o app, uma Splash Screen realiza o carregamento do primeiro lote de produtos. Após concluir, navega automaticamente para a tela de produtos, que exibe a lista com scroll infinito. Como a Fake Store API não possui paginação real, todo o conjunto de produtos (~20) é carregado em uma única requisição e a paginação é feita no cliente, exibindo blocos (chunk) de 10 itens por vez.

## Tecnologias Utilizadas
- Flutter (null-safety)
- Riverpod (providers, injeção de dependências, `ProviderScope`)
- Dio (requisições HTTP, timeouts, tratamento de erros)
- GoRouter (navegação declarativa)
- Cached Network Image (imagens dos produtos com placeholder e fallback)
- Testes com `flutter_test`

## Arquitetura
- Command Pattern:
  - Interface base `Command<T>` com método `execute()` que retorna `Result<T>`.
  - `LoadAllProductsCommand` encapsula a operação de buscar todos os produtos.
- Injeção/containers com Riverpod:
  - `dioProvider` → `apiClientProvider` → `productRepositoryProvider` → `loadAllProductsCommandProvider`.
  - `productListProvider` (StateNotifier) gerencia estado da lista, paginação e erros.
- Camadas:
  - Application (`use-cases`, `repositories`, `dtos`)
  - Domain (`entities`)
  - Infrastructure (`api`, `repositories`)
  - Presentation (`pages`, `widgets`, `state`)

## Funcionalidades
- Splash Screen
  - Exibe ao abrir o app.
  - Carrega o primeiro lote de produtos.
  - Navega automaticamente para a tela de produtos após sucesso.
- Tela de Produtos
  - Lista produtos em um `ListView.builder`.
  - Paginação infinita (carrega mais ao atingir ~90% do fim da lista).
  - Indicadores de carregamento: inicial (`LoadingIndicator`) e no fim da lista (`CircularProgressIndicator`).
  - Tratamento de erro com `ErrorView` e ação “Tentar Novamente”.
  - Snackbar para erros durante paginação.

## Estrutura do Projeto
```
lib/
├── app/
│   ├── app_widget.dart
│   ├── providers.dart
│   └── router.dart
├── application/
│   ├── dtos/
│   ├── repositories/
│   └── use-cases/
├── domain/
│   ├── entities/
│   └── use-cases/
├── infrastructure/
│   ├── api/
│   └── repositories/
├── presentation/
│   ├── pages/
│   ├── state/
│   └── widgets/
└── shared/
    └── utils/
```

## Como Executar
Pré-requisitos:
- Flutter SDK instalado e configurado (`flutter doctor`).
- Plataforma desejada (Android/iOS/web) devidamente preparada.

Passos:
1. Instalar dependências:
   ```bash
   flutter pub get
   ```
2. Executar no dispositivo/simulador em desenvolvimento:
   ```bash
   flutter run
   ```
   - Web (ex.: Chrome):
   ```bash
   flutter run -d chrome
   ```

## Testes
Executar a suíte de testes:
```bash
flutter test
```
Os testes focam a `ProductListPage` e cobrem renderização, estados de loading/erro e comportamento de paginação.

## API e Dados
- Fonte: [Fake Store API](https://fakestoreapi.com)
- Endpoints usados: `GET /products` (retorna todos os produtos; sem paginação).
- DTOs mapeiam JSON para entidades de domínio (`ProductDto` → `Product`).

## Tratamento de Erros e Estados
- `Result<T>` com `Success<T>` e `Failure<T>` para padronizar respostas.
- `ProductRepositoryImpl` converte `DioException` em mensagens amigáveis (timeout, conexão, erro 5xx, etc.).
- `ProductListState` controla flags `isLoading`, `isLoadingMore`, `hasMore` e `error`.


---

## Requisitos Atendidos
- Splash Screen: exibe, carrega e navega automaticamente após sucesso.
- Tela de Produtos: lista em `ListView`, paginação infinita e indicador de carregamento.
- Arquitetura: Command Pattern, Riverpod para containers/injeção, Dio para HTTP.
