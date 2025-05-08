import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navigator/pages/profile.dart';
import 'package:navigator/pages/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedindex = 0;
  String _name = '';
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _email = prefs.getString('email') ?? '';
      _password = prefs.getString('password') ?? '';
    });
  }


  void _updateUserData(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = name;
      _email = email;
      _password = password;
    });
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  void _navigate(int index) {
    setState(() {
      _selectedindex = index;
    });
  }


  List<Widget> get _pages => [
        Profile(name: _name, email: _email, password: _password),
        Settings(
          name: _name,
          email: _email,
          password: _password,
          onSave: _updateUserData,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text(
          "LifeHub",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedindex,
        onTap: _navigate,
        backgroundColor: Colors.indigo[900],
        selectedItemColor: Colors.teal[400],
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[850],
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.star,
                size: 54,
                color: Colors.teal[400],
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month, size: 29, color: Colors.teal[400]),
              title: const Text(
                "C A L E N D A R",
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate, size: 29, color: Colors.teal[400]),
              title: const Text(
                "C A L C U L A T O R",
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calculator');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[900]!, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name.isEmpty ? "Welcome to LifeHub!" : "Welcome, $_name!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                Expanded(child: _pages[_selectedindex]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
