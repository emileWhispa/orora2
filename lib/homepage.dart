import 'package:flutter/material.dart';
import 'package:orora2/account_screen.dart';
import 'package:orora2/dashboard.dart';
import 'package:orora2/finance_dashboard.dart';


class Homepage extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          Dashboard(),
          FinanceDashboard(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart_outlined),label: "Finances"),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Account"),
        ],
      ),
    );
  }
}