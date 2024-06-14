class Product {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'] ??
          'https://via.placeholder.com/150', // Provide a default thumbnail if not available
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
    );
  }
}
