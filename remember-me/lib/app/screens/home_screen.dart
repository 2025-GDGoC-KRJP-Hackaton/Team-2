import 'package:flutter/material.dart';

import '../../constants.dart'; // For color constants

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(''), // Empty title to allow actions to be on the right
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: kInactiveNavTextTeal),
            onPressed: () {
              // Handle menu press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Hello,Kim',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: kDefaultTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Good evening, today is Saturday,\nMay 17',
              style: TextStyle(fontSize: 15, color: kSubTextColor, height: 1.3),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height *
                    0.38, // Adjust height as needed
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/family_dinner.png",
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPaleYellow,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {},
                          child: Text(
                            'View Memories',
                            style: TextStyle(
                              color: kDefaultTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildIconButton(
                  context,
                  Icons.mic_none_outlined,
                  'Voice Input',
                ),
                _buildIconButton(context, Icons.camera_alt_outlined, 'Camera'),
              ],
            ),
            SizedBox(height: 20), // Space for bottom nav bar aesthetics
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String label) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: kDefaultTextColor, size: 28),
      label: Text(
        label,
        style: TextStyle(color: kDefaultTextColor, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPaleYellow,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
      ),
      onPressed: () {},
    );
  }
}
