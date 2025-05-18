import 'package:flutter/material.dart';
import '../../constants.dart'; // For color constants

class MemoryStimulationScreen extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: kDefaultTextColor,
                  size: 36,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Do you remember\nwho this person is?',
                    style: TextStyle(
                      color: kDefaultTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    // Replace with your image asset or network image
                    image: NetworkImage(
                      'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ), // Placeholder
                    fit: BoxFit.cover,
                    onError:
                        (exception, stackTrace) => Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildMemoryButton(context, 'I remember!'),
                  _buildMemoryButton(context, 'Not sure'),
                  _buildMemoryButton(context, 'Next one'),
                ],
              ),
            ),
            SizedBox(height: 10), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryButton(BuildContext context, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPaleYellow,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1,
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            color: kDefaultTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
