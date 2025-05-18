import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/memory_stimulation_screen.dart';
import '../screens/memory_album_screen.dart';
import '../screens/family_dashboard_screen.dart';
import '../../constants.dart'; // Import constants

class AppScaffold extends StatefulWidget {
  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MemoryStimulationScreen(),
    MemoryAlbumScreen(),
    FamilyDashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: ElevatedButton(
    //       onPressed: () async {
    context.push("/login");
    context.pop();
    //         final dio = Dio();
    //         final token = "";
    //         final result = await dio.get(
    //           "http://35.200.118.230/api/v1/users/me",
    //           options: Options(headers: {"Authorization": "bearer {$token}"}),
    //         );
    //         log(result.data.toString());
    //       },
    //       child: Text("API"),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
            _buildNavItem(
              Icons.favorite_border,
              Icons.favorite,
              'Memory\nStimulation',
              1,
              isTwoLines: true,
            ),
            _buildNavItem(
              Icons.photo_album_outlined,
              Icons.photo_album,
              'Memory\nAlbum',
              2,
              isTwoLines: true,
            ),
            _buildNavItem(
              Icons.people_outline,
              Icons.people,
              'Family\nDashboard',
              3,
              isTwoLines: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
    int index, {
    bool isTwoLines = false,
  }) {
    bool isSelected = selectedIndex == index;
    List<String> labelParts = label.split('\n');

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isSelected ? 6.0 : 4.0,
            horizontal: 4.0,
          ),
          margin:
              isSelected
                  ? EdgeInsets.symmetric(horizontal: 4.0)
                  : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isSelected ? kPaleYellow : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                isSelected ? selectedIcon : unselectedIcon,
                color: isSelected ? kActiveNavTextYellow : kInactiveNavTextTeal,
                size: 24,
              ),
              SizedBox(height: 3),
              if (isTwoLines && labelParts.length == 2)
                Column(
                  children: [
                    Text(
                      labelParts[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected
                                ? kActiveNavTextYellow
                                : kInactiveNavTextTeal,
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      labelParts[1],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected
                                ? kActiveNavTextYellow
                                : kInactiveNavTextTeal,
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        height: 1.1,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        isSelected
                            ? kActiveNavTextYellow
                            : kInactiveNavTextTeal,
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
