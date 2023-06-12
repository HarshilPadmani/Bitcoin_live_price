import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/content.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.dark(),
      routes: {
        ContentPage.routeName: (context) => ContentPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = "";
  List<dynamic> articles = [];
  bool isLoading = true;

  Future<void> getData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=483ca47ac3084df9be529770d7bbf53c"));

      if (response.statusCode == 200) {
        setState(() {
          data = response.body;
          articles = jsonDecode(data)['articles'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top 10 Tech News",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 35),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : articles.isEmpty
              ? Center(
                  child: Text('No News articles found.'),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.network(
                                articles[index]['urlToImage'],
                                width: 70,
                                height: 70,
                              ),
                              title: Text(
                                articles[index]['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ContentPage.routeName,
                                    arguments: ContentArguments(
                                      articles[index]['title'],
                                      articles[index]['description'],
                                      articles[index]['url'],
                                    ),
                                  );
                                },
                                child: Text('See full news'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
