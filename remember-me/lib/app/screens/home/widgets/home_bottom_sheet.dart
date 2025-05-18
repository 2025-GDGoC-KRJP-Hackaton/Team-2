import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/screens/home/logic/home_provider.dart';

class HomeBottomSheet extends ConsumerWidget {
  const HomeBottomSheet({super.key});

  void _handleResult(BuildContext context, bool? result) {
    if (result == null) {
      ElegantNotification.info(
        description: Text("Please select an image"),
      ).show(context);
    } else if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image uploaded successfully")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image upload failed")));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(homeProvider.notifier).pickImage();
    return SafeArea(
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text("Camera"),
              leading: Icon(Icons.camera_alt),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Saving Memory"),
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                );
                final result = await ref
                    .read(homeProvider.notifier)
                    .pickImage(isCamera: true);
                Navigator.pop(context);
                _handleResult(context, result);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Gallery"),
              leading: Icon(Icons.photo),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Saving Memory"),
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                );
                final result = await ref
                    .read(homeProvider.notifier)
                    .pickImage(isCamera: false);
                Navigator.pop(context);
                _handleResult(context, result);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
