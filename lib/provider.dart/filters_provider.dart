import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider.dart/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersProviderNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersProviderNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegan: false,
        Filter.vegetarian: false,
      });

  void setFilters(Map<Filter, bool> updatedFilters) {
    state = updatedFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filterProvider = StateNotifierProvider((ref) {
  return FiltersProviderNotifier();
});

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final availableFilters = ref.watch(filterProvider);

  return meals.where((meal) {
    if (availableFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (availableFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (availableFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    if (availableFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
