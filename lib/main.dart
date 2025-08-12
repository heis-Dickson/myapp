import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home_Page(),
    );
  }
}

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(size: 83),
            Expanded(child: Text('Flutter App')),
          ],
        ),
      ),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: Colors.blue, height: 200),
            Divider(),
            Container(color: Colors.blue, height: 200),
            Divider(),
            Container(color: Colors.blue, height: 200),
            Divider(),
            Container(color: Colors.blue, height: 200),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(color: Colors.red),
    );
  }
}