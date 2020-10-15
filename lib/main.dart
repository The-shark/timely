import 'package:timely_timetable/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database.dart';
import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

const AUTH0_DOMAIN = 'dev-8gu5h3hs.us.auth0.com';
const AUTH0_CLIENT_ID = 'WI6DatwasSbqBua1fOFasWpM7cw44V0h';

const AUTH0_REDIRECT_URI = 'com.auth0.timely://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

class Profile extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String name;
  final String picture;

  const Profile(this.logoutAction, this.name, this.picture, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 48),
        RaisedButton(
          onPressed: () async {
            await logoutAction();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

class Loginn extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Loginn(this.loginAction, this.loginError);

  @override
  Widget build(BuildContext context) {
   
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            loginAction();
          },
          child: Text('Login'),
        ),
        Text(loginError ?? ''),
      ],
    );
  }}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
     //FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return MaterialApp(
      title: 'Timely',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Register(),
    );
  }
}
class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;
  UnDrawIllustration illustration = UnDrawIllustration.online_calendar;
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _username;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _success;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
     super.initState();
     Firebase.initializeApp().whenComplete(() {
       print("completed");
       setState(() {
         
       });
     });
    _email = new TextEditingController();
    _password = new TextEditingController();
    _username = new TextEditingController();
     initAction();
   
   
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

  String usernameValidator(String value) {
    if (value.length < 4) {
      return 'Username must be longer than 5 characters';
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
        Center(
          child: isBusy
              ? const CircularProgressIndicator()
              : isLoggedIn
                  ? Profile(logoutAction, name, picture)
                  : Loginn(loginAction, errorMessage),
        ),
        Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: UnDraw(illustration: illustration, color: Colors.cyan)),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _username,
                  validator: usernameValidator,
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Your username",
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
                  controller: _email,
                  validator: emailValidator,
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.email),
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
                      hintText: "********",
                      
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
                    
                      onPressed: ()  {
            
            signUp();
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()));
                      },
                      child: Text(
                        "Sign Up",
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
    )));
  }
   Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    const String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: <String>['openid', 'profile', 'offline_access'],
          // promptValues: ['login']
        ),
      );

      final Map<String, Object> idToken = parseIdToken(result.idToken);
      final Map<String, Object> profile =
          await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }
  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }
    

  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final TokenResponse response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final Map<String, Object> idToken = parseIdToken(response.idToken);
      final Map<String, Object> profile =
          await getUserDetails(response.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } on Exception catch (e, s) {
      debugPrint('error on refresh token: $e - stack: $s');
      await logoutAction();
    }
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  signUp() async {
  if (_formKey.currentState.validate()) {
      setState(() {
        _success = true;
      });
      if (_password.text != null) {
        await _auth
            .createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,)
            .then((currentUser)=> FirebaseFirestore.instance
            .collection("teachers")
            .doc(currentUser.user.uid)
            .set({
              "id":currentUser.user.uid,
              "email": _email.text,
              "username": _username.text,
              "created_at": DateTime.now().millisecondsSinceEpoch.toString()
            })
          .then((result) => {
              if(result = null){
                Fluttertoast.showToast(msg: "Registration failed",
                toastLength:Toast.LENGTH_SHORT,gravity:ToastGravity.BOTTOM)
              }else{
                 Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Login()
              ))
              }
            })
            );}
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
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text(
              'Sign In',
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
