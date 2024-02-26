import 'package:flutter/material.dart';


import '../color.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    // HomeScreen(),
    //
    // CartListScreen(),
    // FavoriteScreen(),
    // ProfileScreen(),

  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: const Color(0xFF181725),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/icons/shopImage.png')),
                  label: 'Shop'),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/icons/exploreImage.png')),
                  label: 'Explore'),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/icons/cartImage.png')),
                  label: 'Cart'),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/icons/FavouriteImage.png')),
                  label: 'Favourite'),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('asset/icons/accountImage.png')),
                  label: 'Account'),
            ],
          ),
        ),
      ),
    );
  }
}
