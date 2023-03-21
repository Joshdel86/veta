import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veta/build_input.dart';
import '../utils.dart';
import 'create_account.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _logInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _logInKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/veta.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              BuildGeneralInput(
                  inputController: _emailController,
                  hint: 'Enter your email',
                  maskText: false,
                  inputKeyboard: TextInputType.emailAddress,
                  onChanged: (value) {}),
              SizedBox(
                height: 8.0,
              ),
              BuildGeneralInput(
                  inputController: _passwordController,
                  hint: 'Enter your password',
                  maskText: true,
                  inputKeyboard: TextInputType.text,
                  onChanged: (value) {}),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      logIn();
                      //Implement login functionality.
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    final isValid = _logInKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      failureSnackBar(context: context, message: e.message.toString());
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext) => RegistrationScreen()));
  }
}
