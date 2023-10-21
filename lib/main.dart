import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Authentication Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}): super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState(){
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account){
      setState(() {
        _currentUser = account;
      });
      if(_currentUser != null){
        print("User is signed in");
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> handleSignIn() async{
    try{
      await _googleSignIn.signIn();
    }catch(error){
      print(error);
    }
  }

  Future<void> handleSignOut() async{
     try{
     _googleSignIn.disconnect();
      setState(() {
        _currentUser = null;
      });
     }catch(error){
        print(error);
      }
  }

  Widget buildBody(){
    GoogleSignInAccount? user = _currentUser;
    if(user!=null){
      return Column(
        children: [
          SizedBox(height: 90,),
          GoogleUserCircleAvatar(identity: user),
          SizedBox(height: 20,),
          Center(
            child: Text(user.displayName ?? '', textAlign: TextAlign.center,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(user.email ?? '', textAlign: TextAlign.center,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(user.id ?? '', textAlign: TextAlign.center,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text("Welcome to CS 184 HW2", textAlign: TextAlign.center,),
          ),
          SizedBox(height: 40,),
          ElevatedButton(onPressed: handleSignOut, child: Text("Sign Out")),
          SizedBox(height: 120,),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SecondSreen()));
          }, child: Text("Go to Second Screen"))
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 90,),
          Padding(
            padding: EdgeInsets.all(8.0), 
            child: Text("Welcome to the login screen of HW2", textAlign: TextAlign.center,),
          ),
          SizedBox(height: 30,),
          Center(
            child: Container(
              width: 250,
              child: ElevatedButton(
                onPressed: handleSignIn, 
                child: Padding(padding:EdgeInsets.all(15.0),
                child: Text("Sign in with Google", textAlign: TextAlign.center,)
                ,),
              )
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: buildBody(),
      ),
    );
  }
}

class SecondSreen extends StatelessWidget {
  const SecondSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          SizedBox(height: 90,),
          Center(child: Text("Welcome to the Second Screen", textAlign: TextAlign.center,)),
          SizedBox(height: 30,),
          Center(child: Text("If you got here you are logged in", textAlign: TextAlign.center,)),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Back"))
        ],
      ),
    );
  }
}