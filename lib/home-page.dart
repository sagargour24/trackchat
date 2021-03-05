import 'package:flutter/material.dart';
import 'package:trackchat/rows_items.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic height = 180;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, 'login');
            },
          ),
        ],
        // automaticallyImplyLeading: false,
        title: Text(
          "BASIC MENU",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body:MediaQuery.of(context).orientation == Orientation.portrait? SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              RowsItemsPortrait("first", "second"),
              SizedBox(
                height: 5.0,
              ),
              RowsItemsPortrait("third", "fourth"),
              SizedBox(
                height: 5.0,
              ),
              RowsItemsPortrait("fifth", "sixth"),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    thumbColor: Colors.yellow,
                    activeTrackColor: Colors.redAccent,
                    overlayColor: Colors.lightGreenAccent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0)),
                child: Slider(
                  value: height.toDouble(),
                  min: 120.0,
                  max: 220.0,
                  // activeColor: Colors.yellow,
                  // inactiveColor: Colors.grey,
                  onChanged: (dynamic v) {
                    setState(() {
                      height = v.round();
                      print(height);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                height.toString(),
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ):SafeArea(
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RowsItemsLandscape("first", "second","third"),
                RowsItemsLandscape("fourth","fifth","sixth"),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      thumbColor: Colors.yellow,
                      activeTrackColor: Colors.redAccent,
                      overlayColor: Colors.lightGreenAccent,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0)),
                  child: Slider(
                    value: height.toDouble(),
                    min: 120.0,
                    max: 220.0,
                    // activeColor: Colors.yellow,
                    // inactiveColor: Colors.grey,
                    onChanged: (dynamic v) {
                      setState(() {
                        height = v.round();
                        print(height);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  height.toString(),
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


