import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider.dart/favourites_provider.dart';
import 'package:meals/provider.dart/meals_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/provider.dart/filters_provider.dart';

const kSelectedFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) => FilterScreen()),
      );
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoryScreen(availableMeals: availableMeals);
    var activeTitle = 'Category';

    final favouriteMeals = ref.watch(favouriteProvider);

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(meals: favouriteMeals);
      activeTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activeTitle)),
      drawer: MainDrawer(onSelectScreen: _selectScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Category',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
