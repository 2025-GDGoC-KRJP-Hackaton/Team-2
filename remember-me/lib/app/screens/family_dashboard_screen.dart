import 'package:flutter/material.dart';
import '../../constants.dart'; // For color constants

class FamilyDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: kInactiveNavTextTeal),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: kHighlightYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Family Dashboar', // Typo as in image
                  style: TextStyle(
                    color: kDefaultTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPaleYellow,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
              ),
              onPressed: () {},
              child: Text(
                'Upload Memory',
                style: TextStyle(
                  color: kDefaultTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Color(0xFFFEFEFE), // Very light fill for the box
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: kInputBorderYellow, width: 2.0),
              ),
              child: Center(
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Icons.add, size: 36, color: Colors.grey[600]),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Category',
              style: TextStyle(
                color: kDefaultTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFFEFEFE),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kInputBorderYellow, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kInputBorderYellow, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kInputBorderYellow, width: 2.5),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreenButton,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
              ),
              onPressed: () {},
              child: Text(
                'Confirm Upload',
                style: TextStyle(
                  color: kGreenButtonText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
