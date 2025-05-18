import 'package:flutter/material.dart';
import '../../constants.dart'; // For color constants

class MemoryAlbumScreen extends StatelessWidget {
  final List<Map<String, String>> photoItems = [
    {
      "image": "https://via.placeholder.com/150/CCCCCC/000000?Text=Family",
      "label": "Family",
    },
    {
      "image": "https://via.placeholder.com/150/CCCCCC/000000?Text=Friend",
      "label": "Friend",
    },
    {
      "image": "https://via.placeholder.com/150/CCCCCC/000000?Text=Travel",
      "label": "Travel",
    },
    {
      "image": "https://via.placeholder.com/150/CCCCCC/000000?Text=Holiday",
      "label": "Holiday",
    },
    {
      "image": "https://via.placeholder.com/150/CCCCCC/000000?Text=Pet",
      "label": "Pet",
    },
    {
      "image": "https://via.placeholder.com/150/CCCCCC/000000?Text=Everyday",
      "label": "Everyday",
    },
  ];

  final List<String> videoLabels = [
    "Family",
    "Friend",
    "Travel",
    "Holiday",
    "Birthday",
    "Wedding",
  ];

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitleChip(
              'Memory Tags!',
              kHighlightYellow,
              fontSize: 22,
              isLarge: true,
            ),
            SizedBox(height: 20),
            _buildSectionTitleChip('Photos', kPaleYellow),
            SizedBox(height: 12),
            _buildImageGrid(photoItems),
            SizedBox(height: 24),
            _buildSectionTitleChip('Videos', kPaleYellow),
            SizedBox(height: 12),
            _buildVideoGrid(videoLabels),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleChip(
    String title,
    Color bgColor, {
    double fontSize = 16,
    bool isLarge = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 18 : 12,
        vertical: isLarge ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isLarge ? 20 : 15),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: kDefaultTextColor,
          fontSize: fontSize,
          fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<Map<String, String>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 3.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(items[index]['image']!),
                    fit: BoxFit.cover,
                    onError:
                        (exception, stackTrace) => Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              items[index]['label']!,
              style: TextStyle(color: kSubTextColor, fontSize: 12),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoGrid(List<String> labels) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 3.8,
      ),
      itemCount: labels.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.grey[600],
                    size: 30,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              labels[index],
              style: TextStyle(color: kSubTextColor, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
