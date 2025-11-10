import '../../domain/entities/rating.dart';

/// DTO para mapeamento de dados de rating da API
class RatingDto {
  final double rate;
  final int count;

  const RatingDto({required this.rate, required this.count});

  /// Cria um RatingDto a partir de JSON
  factory RatingDto.fromJson(Map<String, dynamic> json) {
    return RatingDto(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  /// Converte o DTO para entidade de domínio
  Rating toDomain() {
    return Rating(rate: rate, count: count);
  }
}
