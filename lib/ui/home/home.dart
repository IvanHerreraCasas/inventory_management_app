import 'package:flutter/material.dart';
import 'package:inventory_management_app/ui/home/categories/categories.dart';
import 'package:inventory_management_app/ui/home/sales/sales_page.dart';
import 'package:inventory_management_app/ui/home/purchases/purchases_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: PersistentTabView(
            context,
            navBarStyle: NavBarStyle.style5,
            hideNavigationBarWhenKeyboardShows: true,
            resizeToAvoidBottomInset: true,
            screens: const [
              CategoriesPage(),
              SalesPage(),
              PurchasesPage(),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.search),
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.attach_money_outlined),
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.money_off),
              ),              
            ],
          ),
      ),
    );
  }
}
