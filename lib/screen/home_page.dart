import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '/Widgets/order_tracking_page.dart'; // Adjust the import path as necessary

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=recycling&apiKey=b9e5161e66ec4cecb50c32d86f6bec2a'));
    if (response.statusCode == 200) {
      setState(() {
        articles = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Noticias de Reciclaje',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: articles.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              String title = articles[index]['title'];
                              String description = articles[index]['description'] ?? '';
                              String url = articles[index]['url'];
                              return ListTile(
                                title: Text(title),
                                subtitle: Text(
                                  description.length > 100
                                      ? '${description.substring(0, 100)}...'
                                      : description,
                                ),
                                onTap: () {
                                  _launchURL(url);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderTrackingPage()),
                  );
                },
                child: Text('Show Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: HomePage(),
  routes: {
    '/edit_profile': (context) => EditProfilePage(),
    '/change_phone': (context) => ChangePhonePage(),
    '/manage_alerts': (context) => ManageAlertsPage(),
  },
));

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Page'),
      ),
    );
  }
}

class ChangePhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Phone'),
      ),
      body: Center(
        child: Text('Change Phone Page'),
      ),
    );
  }
}

class ManageAlertsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Alerts'),
      ),
      body: Center(
        child: Text('Manage Alerts Page'),
      ),
    );
  }
}
