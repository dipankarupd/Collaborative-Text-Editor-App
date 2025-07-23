import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenLinkWidget extends StatefulWidget {
  const OpenLinkWidget({super.key});

  @override
  State<OpenLinkWidget> createState() => _OpenLinkWidgetState();
}

class _OpenLinkWidgetState extends State<OpenLinkWidget> {
  final TextEditingController linkController = TextEditingController();

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Paste your link'),
              content: TextField(
                controller: linkController,
                decoration: InputDecoration(
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) async {
                  // Handle Enter key press
                  if (value.trim().isNotEmpty) {
                    Navigator.of(context).pop();
                    linkController.clear(); // Clear the text field
                    final Uri uri = Uri.parse(value.trim());

                    if (uri.scheme.isEmpty ||
                        !(uri.scheme == 'http' || uri.scheme == 'https')) {
                      print('Invalid URL: $value');
                      return;
                    }

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.platformDefault);
                    } else {
                      print('Could not launch: $value');
                    }
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final enteredLink = linkController.text.trim();

                    Navigator.of(context).pop(); // Close the dialog
                    linkController.clear(); // Clear the text field

                    final Uri uri = Uri.parse(enteredLink);

                    // Check if the URL is valid and can be launched
                    if (uri.scheme.isEmpty ||
                        !(uri.scheme == 'http' || uri.scheme == 'https')) {
                      return;
                    }

                    // Attempt to launch the URL in a new tab (on web)
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.platformDefault);
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: Text('Open Link'),
    );
  }
}
