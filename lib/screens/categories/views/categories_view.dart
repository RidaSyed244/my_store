import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_store/screens/categories/model/category_model.dart';
import 'package:my_store/screens/product%20by%20category/views/product_by_category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryModel> allCategories = [];
  List<CategoryModel> filteredCategories = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });

      final response = await http
          .get(Uri.parse('https://dummyjson.com/products/categories'));
      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = jsonDecode(response.body);
        setState(() {
          allCategories = categoriesJson.map((json) {
            Map<String, dynamic> categoryMap = json;
            return CategoryModel.fromJson(categoryMap);
          }).toList();
          filteredCategories = allCategories;
        });
      } else {
        setState(() {
          isError = true;
        });

        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        isError = true;
      });
      throw Exception('Error fetching categories: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterCategories(String query) {
    List<CategoryModel> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = allCategories.where((category) {
        final name = category.name.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    } else {
      filteredList = List.from(allCategories);
    }
    setState(() {
      filteredCategories = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Categories',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterCategories(value);
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${searchController.text.isEmpty ? '0' : filteredCategories.length} results found",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredCategories.isEmpty &&
                          searchController.text.isNotEmpty
                      ? Center(
                          child: Text('No results found'),
                        )
                      : isLoading
                          ? Center(child: CircularProgressIndicator())
                          : isError
                              ? Center(
                                  child: Text(
                                      'Failed to load categories. Please try again.'),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(10.0),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 25.0,
                                    mainAxisSpacing: 25.0,
                                    childAspectRatio: 2 / 2,
                                  ),
                                  itemCount: filteredCategories.length,
                                  itemBuilder: (context, index) {
                                    final category = filteredCategories[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductsByCategory(
                                                        categoryName:
                                                            category.name)));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_FWF2judaujT30K9sMf-tZFhMWpgP6xCemw&s"),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, bottom: 15),
                                              child: Text(
                                                category.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
    );
  }
}
