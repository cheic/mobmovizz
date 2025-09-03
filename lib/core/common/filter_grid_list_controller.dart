import 'package:flutter/material.dart';

/// Classe utilitaire pour gérer l'état du filtre et du mode d'affichage
class FilterGridListController extends ChangeNotifier {
  bool isGridView;
  bool isFiltered;
  int? selectedYear;
  String selectedSort;

  FilterGridListController({
    this.isGridView = true,
    this.isFiltered = false,
    this.selectedYear,
    this.selectedSort = "popularity.desc",
  });

  void toggleView() {
    isGridView = !isGridView;
    notifyListeners();
  }

  void setFilter({required String sort, int? year}) {
    selectedSort = sort;
    selectedYear = year;
    isFiltered = year != null || sort != "popularity.desc";
    notifyListeners();
  }

  void resetFilter() {
    selectedSort = "popularity.desc";
    selectedYear = null;
    isFiltered = false;
    notifyListeners();
  }
}
