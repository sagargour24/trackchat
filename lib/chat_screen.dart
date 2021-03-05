import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackchat/constants.dart';
import 'package:trackchat/map.dart';

enum Popmenu { home, logout, setFromGallery, setByCamera }

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
ScrollController _scrollController = ScrollController();

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin {
  File _image;
  ImagePicker ip;
  AnimationController controller;
  Animation animation;
  final _auth = FirebaseAuth.instance;
  Popmenu _tapped;
  final textController = TextEditingController();
  String messageText;
  bool isBackImg = true;

  @override
  void initState() {
    super.initState();
    ip = ImagePicker();
    getCurrentUser();
    basicAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  getImageFromGallery()async{
    PickedFile pf = await ip.getImage(source: ImageSource.gallery);
    _image = File(pf.path);
    setState(() {
      _image;
    });
  }
  getImageFromCamera()async{
    PickedFile pf = await ip.getImage(source: ImageSource.camera);
    _image = File(pf.path);
    setState(() {
      _image;
    });
  }

  basicAnimation() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.bounceInOut,
    );
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
    });
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<Popmenu>(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.menu,
              color: kBlack,
            ),
            onSelected: (Popmenu result) {
              _tapped = result;
              if (_tapped == Popmenu.home) {
                Navigator.pushNamed(context, 'home');
              } else if (_tapped == Popmenu.logout) {
                _auth.signOut();
                Navigator.pushNamed(context, 'login');
              } else if(_tapped == Popmenu.setFromGallery){
                isBackImg = false;
                getImageFromGallery();
              } else if(_tapped == Popmenu.setByCamera){
                isBackImg = false;
                getImageFromCamera();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Popmenu>>[
              PopupMenuItem<Popmenu>(
                value: Popmenu.home,
                child: Row(
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: kBlack,
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<Popmenu>(
                value: Popmenu.logout,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: kBlack,
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<Popmenu>(
                value: Popmenu.setFromGallery,
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: kBlack,
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<Popmenu>(
                value: Popmenu.setByCamera,
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: kBlack,
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text(
          "Tr@ckCh@t",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: controller.value * 30.0,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: !isBackImg?BoxDecoration(
          image: DecorationImage(
            image: FileImage(_image),
            fit: BoxFit.fitHeight,
          ),
        ):null,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: textController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (messageText.isNotEmpty) {
                          textController.clear();
                          _scrollController
                              .jumpTo(_scrollController.position.maxScrollExtent);
                          try {
                            _firestore.collection('messages').add({
                              'text': messageText,
                              'sender': loggedInUser.email,
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                            messageText = null;
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      onLongPress: () async {
                        String location;
                        textController.clear();
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                        final Position p = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        final loc = Coordinates(p.latitude, p.longitude);
                        var addresses = await Geocoder.local
                            .findAddressesFromCoordinates(loc);
                        var first = addresses.first;
                        setState(() {
                          location = "${first.addressLine}";
                        });
                        try {
                          _firestore.collection('messages').add({
                            'text': messageText,
                            'sender': loggedInUser.email,
                            'timestamp': FieldValue.serverTimestamp(),
                            'address': location,
                            'position': GeoPoint(p.latitude, p.longitude),
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        'send',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageData = message.data();
          final messageText = messageData['text'];
          final messageSender = messageData['sender'];
          final messageTime = messageData['timestamp'];
          final messageAddress = messageData['address'];
          final messagePosition = messageData['position'];

          final currentUser = loggedInUser.email;

          final messageBubble = messagePosition != null
              ? MessageBubble(
                  messageSender,
                  messageTime,
                  currentUser == messageSender,
                  true,
                  null,
                  messageAddress,
                  messagePosition,
                )
              : MessageBubble(
                  messageSender,
                  messageTime,
                  currentUser == messageSender,
                  false,
                  messageText,
                );

          messageBubbles.add(messageBubble); // and here too
        }
        return Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String sender;
  final String text;
  final Timestamp time;
  final bool isMe;
  final String address;
  final GeoPoint geoPoint;
  final bool checkBool;

  MessageBubble(this.sender, this.time, this.isMe, this.checkBool,
      [this.text, this.address, this.geoPoint]);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.sender} at ${DateTime.parse(widget.time.toDate().toString())}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
          Material(
            borderRadius: widget.isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(7.0),
                    bottomLeft: Radius.circular(7.0),
                    bottomRight: Radius.circular(7.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(7.0),
                    bottomRight: Radius.circular(7.0),
                    topRight: Radius.circular(7.0),
                  ),
            elevation: 5.0,
            color: widget.isMe ? Theme.of(context).primaryColor : kcolor1,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: !widget.checkBool
                  ? Text(
                      widget.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          '${widget.address}',
                          style: TextStyle(
                              color: widget.isMe
                                  ? Colors.orange
                                  : Colors.green[900],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Container(
                          width: 400,
                          height: 150,
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              controller.setMapStyle(MapStyle.mapStyle);
                              setState(() {
                                _markers.add(Marker(
                                    markerId: MarkerId("position"),
                                    position: LatLng(widget.geoPoint.latitude,
                                        widget.geoPoint.longitude)));
                              });
                            },
                            markers: _markers,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.geoPoint.latitude,
                                  widget.geoPoint.longitude),
                              zoom: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
