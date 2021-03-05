import 'package:flutter/material.dart';
import 'package:trackchat/new_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class RowsItemsPortrait extends StatelessWidget {
  final String item1;
  final String item2;

  RowsItemsPortrait(this.item1,this.item2);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Cubes(item: item1),
        ),
        SizedBox(
          width: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Cubes(item: item2),
        )
      ],
    );
  }
}

class RowsItemsLandscape extends StatelessWidget {
  final String item1;
  final String item2;
  final String item3;

  RowsItemsLandscape(this.item1,this.item2,this.item3);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Cubes(item: item1),
        ),
        SizedBox(
          width: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Cubes(item: item2),
        ),
        SizedBox(
          width: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Cubes(item: item3),
        ),
      ],
    );
  }
}

class Cubes extends StatefulWidget {
  const Cubes({
    Key key,
    @required this.item,
  }) : super(key: key);

  final String item;



  @override
  _CubesState createState() => _CubesState();
}

class _CubesState extends State<Cubes> {
  String _location;
  void getLocation()async{
    final Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final loc = Coordinates(p.latitude, p.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(loc);
    var first = addresses.first;
    setState(() {
      _location = "${first.addressLine}";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          width: 110.0,
          height: 100.0,
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.lightGreenAccent,
            //     blurRadius: 25.0,
            //     spreadRadius: 5.0,
            //     offset: Offset(
            //       15.0,
            //       15.0,
            //     ),
            //   ),
            // ],
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Text(
              widget.item,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ),
        ),
        onTap: () {
          getLocation();
          if (widget.item == 'first') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return NewPage(widget.item,_location);
            }));
          } else if (widget.item == 'third') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return NewPage(widget.item,_location);
            }));
          } else if (widget.item == 'fifth') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return NewPage(widget.item,_location);
            }));
          }
          else if (widget.item == 'second') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return NewPage(widget.item,_location);
            }));
          } else if (widget.item == 'fourth') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return NewPage(widget.item,_location);
            }));
          } else if (widget.item == 'sixth') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return NewPage(widget.item,_location);
            }));
          }
        },
      ),
    );
  }
}

