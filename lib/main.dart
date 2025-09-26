import 'package:flutter/material.dart';
import 'package:flutter_repkeep/providers/workout_provider.dart';
import 'package:flutter_repkeep/screens/check_screen.dart';
import 'package:flutter_repkeep/screens/dashboard_screen.dart';
import 'package:flutter_repkeep/screens/test_screen.dart';
import 'package:flutter_repkeep/screens/workout_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(ChangeNotifierProvider(
    create: (context) => WorkoutProvider(),
    child: const RepKeeps(),
  ));
}

class RepKeeps extends StatelessWidget {
  const RepKeeps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RepKeeps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // Primary Blue
          primary: const Color.fromARGB(255, 86, 151, 226),
          secondary: const Color(0xFF42A5F5), // Secondary Blue Accent
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    WorkoutListScreen(),
    CheckScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Check',
          ),
        ],
      ),
    );
  }
}
