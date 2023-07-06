import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timeless",
          style: GoogleFonts.kalam(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.bag,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text("Home Page"),
          )),
    );
  }
}
