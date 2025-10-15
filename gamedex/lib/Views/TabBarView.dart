import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/TabBarViewModel.dart';
import 'TabBarScreensViews/HomeScreenView.dart';
import 'TabBarScreensViews/ProfileScreenView.dart';
import 'TabBarScreensViews/WishlistScreenView.dart';



class TabBarView extends StatelessWidget {
  const TabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      HomeScreenView(),
      WishlistScreenView(),
      ProfileScreenView(),
    ];

    return ChangeNotifierProvider(
      create: (_) => TabBarViewModel(),
      child: Consumer<TabBarViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: SafeArea(child: pages[viewModel.selectedIndex]),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
              selectedItemColor: Colors.purple,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: "Wishlist",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
