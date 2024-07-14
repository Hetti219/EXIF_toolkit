import 'package:exif_toolkit/authentication/auth_service.dart';
import 'package:exif_toolkit/authentication/input_validator.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = AuthService();

  //Controllers
  final _email = TextEditingController();

  //Error messages
  String? _emailError;

  @override
  void initState() {
    super.initState();

    _email.addListener(_validateEmail);
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
  }

  //Email Validator
  void _validateEmail() {
    setState(() {
      _emailError = EmailValidator.validate(_email.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/Gemini_Generated_Image_exos46exos46exos.jpeg',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Enter Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      errorText: _emailError),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
