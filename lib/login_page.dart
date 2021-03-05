import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trackchat/constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  bool _show = false;
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: kcolor2, end: kcolor1).animate(controller);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _show,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10.0),
              ),
            ),
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                "Tr@ckCh@t",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/backimage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MediaQuery.of(context).orientation == Orientation.portrait?Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: textController,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Email Id",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 3.0,
                              ),
                            ),
                          ),
                          validator: (v){
                            if(v.isEmpty){
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: textController2,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            icon: Icon(
                              Icons.login,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 3.0,
                              ),
                            ),
                          ),
                          validator: (v){
                            if(v.isEmpty){
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 100.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: kcolor3,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ),
                        onTap: ()async {
                            if(_formkey.currentState.validate()) {
                              _show = true;
                              try {
                                final _user = await _auth
                                    .signInWithEmailAndPassword(
                                    email: _email, password: _password);
                                if (_user != null) {
                                  Navigator.pushNamed(context, 'chat');
                                  textController.clear();
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 125.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ),
                        onTap: ()async{
                          if(_formkey.currentState.validate()) {
                            _show = true;
                            try {
                              final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                              if (newUser != null) {
                                Navigator.pushNamed(context, 'chat');
                                textController2.clear();
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ):SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            autofocus: true,
                            cursorColor: Theme.of(context).primaryColor,
                            controller: textController,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: "Email Id",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            validator: (v){
                              if(v.isEmpty){
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            autofocus: true,
                            cursorColor: Theme.of(context).primaryColor,
                            controller: textController2,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              icon: Icon(
                                Icons.login,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            validator: (v){
                              if(v.isEmpty){
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 100.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: kcolor3,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                          onTap: ()async {
                            if(_formkey.currentState.validate()) {
                              _show = true;
                              try {
                                final _user = await _auth
                                    .signInWithEmailAndPassword(
                                    email: _email, password: _password);
                                if (_user != null) {
                                  Navigator.pushNamed(context, 'chat');
                                  textController.clear();
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 125.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                          onTap: ()async{
                            if(_formkey.currentState.validate()) {
                              _show = true;
                              try {
                                final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                                if (newUser != null) {
                                  Navigator.pushNamed(context, 'chat');
                                  textController2.clear();
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
