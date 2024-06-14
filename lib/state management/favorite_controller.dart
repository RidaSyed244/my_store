import 'package:get/get.dart';
import 'package:my_store/screens/product%20by%20details/model/fvrt_product_model.dart';

class FavoriteController extends GetxController {
  RxList<Product> favorites = <Product>[].obs;
  RxList<Product> filteredFavorites = <Product>[].obs;

  bool isFavorite(int productId) {
    return favorites.any((product) => product.id == productId);
  }

  void addToFavorites(Product product) {
    if (!favorites.contains(product)) {
      favorites.add(product);
      filteredFavorites.add(product);
      update();
    }
  }

  void removeFromFavorites(int productId) {
    favorites.removeWhere((product) => product.id == productId);
    filteredFavorites.removeWhere((product) => product.id == productId);
    update();
  }

  void searchFavorites(String query) {
    if (query.isEmpty) {
      filteredFavorites.assignAll(favorites);
    } else {
      filteredFavorites.assignAll(
        favorites
            .where((product) =>
                product.title.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
    update();
  }
}
