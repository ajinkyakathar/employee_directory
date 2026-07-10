import 'package:flutter/material.dart';
import 'package:employee_directory/providers/employee_provider.dart';

class FilterSortBar extends StatelessWidget {
  final GenderFilter genderFilter;
  final SortOrder sortOrder;
  final bool showFavoritesOnly;
  final ValueChanged<GenderFilter> onGenderChanged;
  final ValueChanged<SortOrder> onSortChanged;
  final VoidCallback onFavoritesToggle;

  const FilterSortBar({
    super.key,
    required this.genderFilter,
    required this.sortOrder,
    required this.showFavoritesOnly,
    required this.onGenderChanged,
    required this.onSortChanged,
    required this.onFavoritesToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _GenderChip(
            label: 'All',
            selected: genderFilter == GenderFilter.all,
            onTap: () => onGenderChanged(GenderFilter.all),
          ),
          const SizedBox(width: 8),
          _GenderChip(
            label: 'Male',
            selected: genderFilter == GenderFilter.male,
            onTap: () => onGenderChanged(GenderFilter.male),
          ),
          const SizedBox(width: 8),
          _GenderChip(
            label: 'Female',
            selected: genderFilter == GenderFilter.female,
            onTap: () => onGenderChanged(GenderFilter.female),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Favorites'),
            avatar: Icon(
              Icons.favorite,
              size: 16,
              color: showFavoritesOnly ? Colors.white : Colors.redAccent,
            ),
            selected: showFavoritesOnly,
            onSelected: (_) => onFavoritesToggle(),
            selectedColor: Colors.redAccent,
            labelStyle: TextStyle(color: showFavoritesOnly ? Colors.white : null),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<SortOrder>(
            initialValue: sortOrder,
            onSelected: onSortChanged,
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => const [
              PopupMenuItem(value: SortOrder.aToZ, child: Text('Name: A to Z')),
              PopupMenuItem(value: SortOrder.zToA, child: Text('Name: Z to A')),
              PopupMenuItem(value: SortOrder.none, child: Text('No sorting')),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(color: selected ? Colors.white : null),
    );
  }
}