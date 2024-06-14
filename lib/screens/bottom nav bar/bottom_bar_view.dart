import 'package:flutter/material.dart';
import 'package:my_store/screens/categories/views/categories_view.dart';
import 'package:my_store/screens/favorite/views/fvrt_views.dart';
import 'package:my_store/screens/products/views/products_view.dart';
import 'package:my_store/screens/profile/views/profile_view.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0; // Current selected index

  static List<Widget> _screens = <Widget>[
    ProductsScreen(),
    CategoriesScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(
                0, Icons.production_quantity_limits_outlined, 'Products'),
            buildNavBarItem(1, Icons.category, 'Categories'),
            buildNavBarItem(2, Icons.favorite_outline, 'Favourites'),
            buildNavBarItem(3, Icons.person_2_outlined, 'Rida Syed'),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(int index, IconData iconData, String text) {
    bool isSelected = _selectedIndex == index;
    Color color = isSelected ? Colors.white : Colors.white;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        color: isSelected ? Color.fromRGBO(24, 24, 24, 1) : Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: color,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
