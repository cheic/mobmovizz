import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobmovizz/core/theme/theme_bloc.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, String> sortOptions;
  final String initialSort;
  final int? initialYear;
  final Function(String sortBy, int? year) onApply;
  final VoidCallback? onReset;
  final String title;
  final Color? backgroundColor;
  final Color? accentColor;

  const FilterDialog({
    super.key,
    required this.sortOptions,
    required this.initialSort,
    required this.initialYear,
    required this.onApply,
    this.onReset,
    this.title = '',  // Titre vide par défaut, sera traduit automatiquement
    this.backgroundColor,
    this.accentColor,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();

  // Méthode statique pour faciliter l'utilisation
  static Future<void> show({
    required BuildContext context,
    required Map<String, String> sortOptions,
    required String initialSort,
    required int? initialYear,
    required Function(String sortBy, int? year) onApply,
    VoidCallback? onReset,
    String title = '',  // Titre vide par défaut, sera traduit automatiquement
    Color? backgroundColor,
    Color? accentColor,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5), // Valeur par défaut, sera adaptée dynamiquement
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        // Envelopper le dialog dans un BlocBuilder pour réagir aux changements de thème
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            // Adapter la couleur de la barrière selon le thème actuel
            final isLightMode = themeState.themeMode == 1 || 
                (themeState.themeMode == 0 && MediaQuery.of(context).platformBrightness == Brightness.light);
            
            return Container(
              color: isLightMode 
                  ? Colors.black.withValues(alpha: 0.3)  // Plus clair en mode clair
                  : Colors.black.withValues(alpha: 0.6), // Plus sombre en mode sombre
              child: FilterDialog(
                sortOptions: sortOptions,
                initialSort: initialSort,
                initialYear: initialYear,
                onApply: onApply,
                onReset: onReset,
                title: title,
                backgroundColor: backgroundColor,
                accentColor: accentColor,
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0); // Commence en haut de l'écran
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

class _FilterDialogState extends State<FilterDialog> {
  late String _selectedSort;
  late int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
    _selectedYear = widget.initialYear;
  }

  Color getBackgroundColor(ThemeState themeState, BuildContext context) {
    // Toujours utiliser la logique adaptative, ignorer widget.backgroundColor
    final isLightMode = themeState.themeMode == 1 || 
        (themeState.themeMode == 0 && MediaQuery.of(context).platformBrightness == Brightness.light);
    
    return isLightMode ? Colors.white : Theme.of(context).colorScheme.surface;
  }
  
  Color getSecondaryColor(ThemeState themeState, BuildContext context) {
    // Toujours utiliser la logique adaptative
    final isLightMode = themeState.themeMode == 1 || 
        (themeState.themeMode == 0 && MediaQuery.of(context).platformBrightness == Brightness.light);
    
    return isLightMode 
        ? Colors.grey.shade50 
        : Theme.of(context).colorScheme.surfaceContainer;
  }
  
  Color get accentColor => Theme.of(context).colorScheme.primary; // Utiliser toujours la couleur du thème

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.85, // 85% de la hauteur
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10, // Respecte la status bar
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: getBackgroundColor(themeState, context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Handle bar pour indiquer que c'est draggable
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(themeState, context),
                      const SizedBox(height: 24),
                      _buildSortSection(themeState, context),
                      const SizedBox(height: 20),
                      _buildYearSection(themeState, context),
                      const SizedBox(height: 12),
                      _buildYearList(themeState, context),
                      const SizedBox(height: 24),
                      _buildActionButtons(themeState, context),
                      const SizedBox(height: 16), // Padding bottom pour les boutons
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
        }
      );
  }

  Widget _buildHeader(ThemeState themeState, BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.tune,
            color: accentColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          AppLocalizations.of(context)?.filters_and_sort ?? 'Filtres et Tri',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection(ThemeState themeState, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getSecondaryColor(themeState, context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sort,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)?.sort_by ?? 'Trier par',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: getBackgroundColor(themeState, context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: DropdownButton<String>(              value: _selectedSort,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: getSecondaryColor(themeState, context),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              items: widget.sortOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
                    
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSort = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSection(ThemeState themeState, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getSecondaryColor(themeState, context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)?.filter_by_year ?? 'Filtrer par année',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAllYearsOption(themeState, context),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAllYearsOption(ThemeState themeState, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _selectedYear == null 
            ? accentColor.withValues(alpha: 0.2)
            : getBackgroundColor(themeState, context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _selectedYear == null 
              ? accentColor
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _selectedYear = null;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16, // Plus de padding vertical
          ),
          child: Row(
            children: [
              Radio<int?>(
                value: null,
                groupValue: _selectedYear,
                activeColor: accentColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return accentColor;
                  }
                  return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
                }),
                onChanged: (int? value) {
                  setState(() {
                    _selectedYear = null;
                  });
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.all_years ?? 'Toutes les années',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 16, // Taille de police plus grande
                  ),
                ),
              ),
              if (_selectedYear == null)
                Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearList(ThemeState themeState, BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: getSecondaryColor(themeState, context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: DateTime.now().year - 1900 + 1,
            itemBuilder: (context, index) {
              final year = DateTime.now().year - index;
              final isSelected = _selectedYear == year;
              
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? accentColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected 
                      ? Border.all(color: accentColor, width: 1.5)
                      : Border.all(color: Colors.transparent, width: 1.5),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _selectedYear = year;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16, // Plus de padding vertical
                    ),
                    child: Row(
                      children: [
                        Radio<int?>(
                          value: year,
                          groupValue: _selectedYear,
                          activeColor: accentColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return accentColor;
                            }
                            return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
                          }),
                          onChanged: (int? value) {
                            setState(() {
                              _selectedYear = year;
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              color: isSelected ? accentColor : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected 
                                  ? FontWeight.bold 
                                  : FontWeight.w500,
                              fontSize: 16, // Taille de police plus grande
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: accentColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeState themeState, BuildContext context) {
    return Row(
      children: [
        if (widget.onReset != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedSort = widget.sortOptions.keys.first;
                  _selectedYear = null;
                });
                Navigator.of(context).pop();
                widget.onReset!();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)?.reset ?? 'Reset',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)?.cancel ?? 'Annuler',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onApply(_selectedSort, _selectedYear);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              AppLocalizations.of(context)?.apply ?? 'Appliquer',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}