import 'package:flutter/material.dart';
import 'package:employee_directory/models/employee.dart';
import 'package:employee_directory/services/api_service.dart';
import 'package:employee_directory/services/favorites_service.dart';

enum GenderFilter { all, male, female }

enum SortOrder { none, aToZ, zToA }

class EmployeeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FavoritesService _favoritesService = FavoritesService();

  List<Employee> _allEmployees = [];
  Set<int> _favoriteIds = {};

  bool isLoading = false;
  String? errorMessage;

  String searchQuery = '';
  GenderFilter genderFilter = GenderFilter.all;
  SortOrder sortOrder = SortOrder.none;
  bool showFavoritesOnly = false;

  List<Employee> get employees => _applyFilters();

  bool isFavorite(int id) => _favoriteIds.contains(id);

  /// Loads the employee list from the API and restores saved favorites.
  Future<void> loadEmployees() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.fetchEmployees(),
        _favoritesService.loadFavorites(),
      ]);

      _allEmployees = results[0] as List<Employee>;
      _favoriteIds = results[1] as Set<int>;
    } catch (e) {
      errorMessage = 'Could not load employees. Please check your connection and try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void updateGenderFilter(GenderFilter filter) {
    genderFilter = filter;
    notifyListeners();
  }

  void updateSortOrder(SortOrder order) {
    sortOrder = order;
    notifyListeners();
  }

  void toggleShowFavoritesOnly() {
    showFavoritesOnly = !showFavoritesOnly;
    notifyListeners();
  }

  Future<void> toggleFavorite(int employeeId) async {
    if (_favoriteIds.contains(employeeId)) {
      _favoriteIds.remove(employeeId);
    } else {
      _favoriteIds.add(employeeId);
    }
    notifyListeners();
    await _favoritesService.saveFavorites(_favoriteIds);
  }

  List<Employee> _applyFilters() {
    var list = List<Employee>.from(_allEmployees);

    if (showFavoritesOnly) {
      list = list.where((e) => _favoriteIds.contains(e.id)).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      list = list.where((e) => e.fullName.toLowerCase().contains(query)).toList();
    }

    if (genderFilter == GenderFilter.male) {
      list = list.where((e) => e.gender.toLowerCase() == 'male').toList();
    } else if (genderFilter == GenderFilter.female) {
      list = list.where((e) => e.gender.toLowerCase() == 'female').toList();
    }

    if (sortOrder == SortOrder.aToZ) {
      list.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
    } else if (sortOrder == SortOrder.zToA) {
      list.sort((a, b) => b.fullName.toLowerCase().compareTo(a.fullName.toLowerCase()));
    }

    return list;
  }
}