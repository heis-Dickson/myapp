import 'package:flutter/material.dart';
import 'package:myapp/screens/home_page.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home_Page()
    );
  }
}