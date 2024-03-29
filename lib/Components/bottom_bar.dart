import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tomatoes/favorite/favoritePage.dart';
import 'package:tomatoes/homePage/homePage.dart';
import 'package:tomatoes/invertory/inventoryPage.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/personal/personal.dart';
import 'package:tomatoes/recipe/mainPage.dart';

class bottom_bar extends StatefulWidget {
  const bottom_bar({super.key});

  @override
  State<bottom_bar> createState() => _bottom_barState();
}

class _bottom_barState extends State<bottom_bar> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  int _selectedIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   final currentUser = FirebaseAuth.instance.currentUser!;
  //   currentUserUID = currentUser.uid;
  // }

  @override
  Widget build(BuildContext context) {
    final String currentUserUID = currentUser.uid;
    List<Widget> bar = [
      const homePage(),
      const mainPage(),
      const favoritePage(),
      const inventoryPage(),
      Personal_Page(
        userUid: currentUserUID,
        isLeading: false,
      ),
    ];
    return Scaffold(
      body: bar.elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: thisSize.width * .05,
          right: thisSize.width * .05,
          bottom: thisSize.height * .025,
          top: 1,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFE2DC),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: GNav(
              rippleColor: const Color(0xFFFFE2DC),
              hoverColor: const Color(0xFFFC6D59),
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: const Color(0xFFF83015),
              // padding: EdgeInsets.all(15),
              gap: 4,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                ),
                GButton(
                  icon: Icons.description_outlined,
                  text: 'Recipe',
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'Favorite',
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                ),
                GButton(
                  icon: Icons.shopping_bag_outlined,
                  text: 'Inventory',
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                ),
                GButton(
                  icon: Icons.person_2_outlined,
                  text: 'Profile',
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
    //);
  }
}
