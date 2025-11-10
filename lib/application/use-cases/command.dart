import '../../shared/utils/result.dart';

/// Interface base para o Command Pattern
///
/// Encapsula uma operação de negócio que retorna um Result<T>
abstract class Command<T> {
  /// Executa o comando e retorna um Result
  Future<Result<T>> execute();
}
