import 'package:exif_toolkit/authentication/auth_service.dart';
import 'package:exif_toolkit/authentication/device_details.dart';
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
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
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
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Note: The email you entered will be registered with the device's ID so that you can only login to the app using the above entered email only. You can reset the associated device later.",
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20)),
                child: Text(
                  'Sign up',
                  style: theme.textTheme.labelLarge,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _signup() async {
    final deviceId = DeviceDetails().getDeviceId();
    final user = await _auth.createUserWithEmailAndDeviceId(
        _email.text, deviceId.toString());

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/login_page');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "User Sign up successful.",
        style: Theme.of(context).textTheme.bodyMedium,
      )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Sign up failed.",
        style: Theme.of(context).textTheme.bodyMedium,
      )));
    }
  }
}
