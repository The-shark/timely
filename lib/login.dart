import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:timely_timetable/bottmNavigation.dart';
import 'package:timely_timetable/main.dart';
import 'database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UnDrawIllustration illustration = UnDrawIllustration.online_calendar;
  TextEditingController _email;
  TextEditingController _password;

  final _formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    _email = new TextEditingController();
    _password = new TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 5) {
      return 'Password must be longer than 5 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: UnDraw(illustration: illustration, color: Colors.cyan)),
        Form(
          key: _formKey,
           child:Column(
             children: <Widget>[
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _email,
                  validator: emailValidator,
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Your email",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(color: Colors.cyan),
                      )),
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(fontFamily: "Poppins"),
                ),
          ),
             
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextFormField(
            controller: _password,
            validator: pwdValidator,
             obscureText: true,
            decoration: new InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Your password",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(color: Colors.cyan),
                )),
            keyboardType: TextInputType.text,
            style: new TextStyle(fontFamily: "Poppins"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).primaryColor,
            child: MaterialButton(
                onPressed: () {
                  signIn();
                },
                child: Text(
                  "Sign In",
                )),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.centerRight,
          child: _createAccountLabel(),
        ),
  ],
           ),
        ),
      ],
    ),
    ),
    );
  }

  
  signIn() async {
    //var firebaseUser = await FirebaseAuth.instance.currentUser;

    if (_formKey.currentState.validate()) {
      if (_password.text != null) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _email.text, password: _password.text)
            .then((currentUser) => FirebaseFirestore.instance
                .collection("teachers")
                .doc(currentUser.user.uid)
                .get()
                .then((DocumentSnapshot result) =>{
                 if(result == null){
                Fluttertoast.showToast(msg: "Login failed",
                toastLength:Toast.LENGTH_SHORT,gravity:ToastGravity.BOTTOM)
              }else{
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigation(
                             //username: result["username"],
                             // id: currentUser.user.uid,
                            )))}
                })
                .catchError((err) => print(err)))
            .catchError((err) => print(err));
      }
    }
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

