import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_store/constants/constants.dart';
import 'package:my_store/state%20management/favorite_controller.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FavoriteController _favoriteController =
        Get.put(FavoriteController());

    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: 'Favorites',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: searchController,
              onChanged: (value) {
                _favoriteController.searchFavorites(value);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              final resultsCount = _favoriteController.filteredFavorites.length;
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${searchController.text.isEmpty ? '0' : resultsCount} results found",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (_favoriteController.filteredFavorites.isEmpty) {
                return Center(
                  child: Text('No favorite products.'),
                );
              } else {
                return ListView.builder(
                  itemCount: _favoriteController.filteredFavorites.length,
                  itemBuilder: (context, index) {
                    final product =
                        _favoriteController.filteredFavorites[index];
                    return ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(
                          product.thumbnail,
                        ),
                      ),
                      title: Text(
                        product.title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("\$${product.price.toString()}"),
                          Row(
                            children: [
                              Text("${product.rating.toString()}"),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    color: starIndex < product.rating
                                        ? Colors.yellow
                                        : Colors.grey,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          _favoriteController.removeFromFavorites(product.id);
                        },
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
