import 'package:flutter/material.dart';

class NewPage extends StatefulWidget {
  final String text;
  final String coords;
  NewPage(this.text, this.coords);

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: GestureDetector(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Welcome to ${widget.text.toString()} page and co-ordinates are:- ${widget.coords.toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
