import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veta/main.dart';
import 'package:veta/screens/login.dart';
import '../build_input.dart';
import '../utils.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _regKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _regKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/veta.png'),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                    child: Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 48.0,
                ),
                BuildGeneralInput(
                  inputKeyboard: TextInputType.text,
                  maskText: false,
                  inputController: _firstNameController,
                  onChanged: (value) {},
                  hint: 'Enter first name',
                ),
                SizedBox(
                  height: 8.0,
                ),
                BuildGeneralInput(
                  inputKeyboard: TextInputType.text,
                  maskText: false,
                  inputController: _lastNameController,
                  onChanged: (value) {},
                  hint: 'Enter last name',
                ),
                SizedBox(
                  height: 8.0,
                ),
                BuildGeneralInput(
                  inputKeyboard: TextInputType.emailAddress,
                  maskText: false,
                  inputController: _emailController,
                  onChanged: (value) {},
                  hint: 'Enter email',
                ),
                SizedBox(
                  height: 8.0,
                ),
                BuildGeneralInput(
                  inputKeyboard: TextInputType.text,
                  maskText: true,
                  inputController: _passwordController,
                  onChanged: (value) {},
                  hint: 'Enter password',
                ),
                SizedBox(
                  height: 8.0,
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () {
                        signUp();
                        //Implement registration functionality.
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = _regKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        // FirebaseFirestore.instance
        //     .collection('userData')
        //     .doc(value.user!.uid)
        //     .set({
        //   'email': value.user!.email,
        //   'first_name': _firstNameController.text,
        //   'last_name': _lastNameController.text,
        //   'password': _passwordController.text,
        // });
      });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (Context) => RegistrationScreen()));
    } on FirebaseAuthException catch (e) {
      failureSnackBar(context: context, message: e.message.toString());
    }
  }
}
