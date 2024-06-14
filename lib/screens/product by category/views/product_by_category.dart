import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_store/screens/product%20by%20details/views/product_by_details.dart';

class ProductsByCategory extends StatefulWidget {
  final String categoryName;

  const ProductsByCategory({Key? key, required this.categoryName})
      : super(key: key);

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  List<dynamic> matchedProducts = [];
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products?limit=100'));
      if (response.statusCode == 200) {
        setState(() {
          allProducts = jsonDecode(response.body)['products'];
          filteredProducts = List.from(allProducts);
          matchedProducts = filteredProducts
              .where((product) =>
                  product['category'].toString().toLowerCase() ==
                  widget.categoryName.toLowerCase())
              .toList();
        });
      } else {
        setState(() {
          isError = true;
        });
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isError = true;
      });
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        matchedProducts = filteredProducts
            .where((product) =>
                product['category'].toString().toLowerCase() ==
                widget.categoryName.toLowerCase())
            .toList();
      } else {
        matchedProducts = filteredProducts
            .where((product) =>
                product['category'].toString().toLowerCase() ==
                    widget.categoryName.toLowerCase() &&
                (product['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.categoryName,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
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
                filterProducts(value);
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
                "${searchController.text.isEmpty ? '0' : matchedProducts.length} results found",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? Center(
                        child:
                            Text('Failed to load products. Please try again.'),
                      )
                    : matchedProducts.isEmpty &&
                            searchController.text.isNotEmpty
                        ? Center(
                            child: Text('No products found.',
                                style: TextStyle(color: Colors.black)))
                        : ListView.builder(
                            itemCount: matchedProducts.length,
                            itemBuilder: (context, index) {
                              final product = matchedProducts[index];
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductByDeatils(
                                                      productId:
                                                          product["id"])));
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.black,
                                              child: Image.network(
                                                product["thumbnail"],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    product['title'] ?? '',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${product['price'] ?? 0}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${product["rating"]}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: List.generate(5,
                                                      (starIndex) {
                                                    return Icon(
                                                      Icons.star,
                                                      color: starIndex <
                                                              product["rating"]
                                                          ? Colors.yellow
                                                          : Colors.grey,
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${product["brand"] ?? "Not Brand Available"}",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${product["availabilityStatus"]}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
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
