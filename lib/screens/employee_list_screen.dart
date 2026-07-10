import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:employee_directory/providers/employee_provider.dart';
import 'package:employee_directory/widgets/employee_card.dart';
import 'package:employee_directory/widgets/search_bar_widget.dart';
import 'package:employee_directory/widgets/filter_sort_bar.dart';
import 'package:employee_directory/screens/employee_detail_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    // Kick off the fetch right after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Directory'),
        centerTitle: false,
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return _ErrorState(
              message: provider.errorMessage!,
              onRetry: provider.loadEmployees,
            );
          }

          final employees = provider.employees;

          return Column(
            children: [
              SearchBarWidget(onChanged: provider.updateSearch),
              const SizedBox(height: 4),
              FilterSortBar(
                genderFilter: provider.genderFilter,
                sortOrder: provider.sortOrder,
                showFavoritesOnly: provider.showFavoritesOnly,
                onGenderChanged: provider.updateGenderFilter,
                onSortChanged: provider.updateSortOrder,
                onFavoritesToggle: provider.toggleShowFavoritesOnly,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: employees.isEmpty
                    ? const _EmptyState()
                    : RefreshIndicator(
                  onRefresh: provider.loadEmployees,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return EmployeeCard(
                        employee: employee,
                        isFavorite: provider.isFavorite(employee.id),
                        onFavoriteTap: () => provider.toggleFavorite(employee.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeDetailScreen(employee: employee),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text('No employees match your filters', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}