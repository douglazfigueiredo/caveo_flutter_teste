import '../../domain/entities/product.dart';
import 'rating_dto.dart';

/// DTO para mapeamento de dados de produto da API
class ProductDto {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingDto rating;

  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  /// Cria um ProductDto a partir de JSON
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: RatingDto.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }

  /// Converte o DTO para entidade de domínio
  Product toDomain() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.toDomain(),
    );
  }
}
