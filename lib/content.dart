import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  static const routeName = '/content';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ContentArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              args.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(args.description),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentArguments {
  String title;
  String description;
  String url;

  ContentArguments(this.title, this.description, this.url);
}
