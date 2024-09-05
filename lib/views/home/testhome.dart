import 'package:flutter/material.dart';
import 'package:recce/configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreenTest extends StatefulWidget {
  const HomeScreenTest({super.key});

  @override
  State<HomeScreenTest> createState() => _HomeScreenTestState();
}

class _HomeScreenTestState extends State<HomeScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: const Icon(Icons.logout),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    print('Current isLoggedIn value before clear: ${prefs.getBool('isLoggedIn')}');

    // Use Navigator directly to handle navigation
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    }
  }
}
