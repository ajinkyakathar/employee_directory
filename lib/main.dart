import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:employee_directory/providers/employee_provider.dart';
import 'package:employee_directory/screens/employee_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmployeeProvider(),
      child: MaterialApp(
        title: 'Employee Directory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF3B5BFD),
          scaffoldBackgroundColor: const Color(0xFFF7F8FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF7F8FA),
            foregroundColor: Colors.black87,
            elevation: 0,
          ),
        ),
        home: const EmployeeListScreen(),
      ),
    );
  }
}