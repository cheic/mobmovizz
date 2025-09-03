import 'package:flutter/material.dart';

/// Widget réutilisable pour le header de filtre + switch grid/liste
class FilterHeader extends StatelessWidget {
  final bool isGridView;
  final bool isFiltered;
  final VoidCallback onFilter;
  final VoidCallback onToggleView;
  final Color? filterActiveColor;

  const FilterHeader({
    super.key,
    required this.isGridView,
    required this.isFiltered,
    required this.onFilter,
    required this.onToggleView,
    this.filterActiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: isFiltered 
                ? (filterActiveColor ?? Theme.of(context).colorScheme.primary) 
                : Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: onFilter,
        ),
        IconButton(
          icon: Icon(
            isGridView ? Icons.list : Icons.grid_on, 
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: onToggleView,
        ),
      ],
    );
  }
}
