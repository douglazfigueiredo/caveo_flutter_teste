/// Tipo Result para tratamento de erros usando sealed classes
sealed class Result<T> {
  const Result();
}

/// Representa um resultado bem-sucedido
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// Representa uma falha com mensagem de erro
class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;

  const Failure(this.message, [this.exception]);
}
