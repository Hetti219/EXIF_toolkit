import 'package:exif_toolkit/authentication/auth_service.dart';
import 'package:exif_toolkit/authentication/device_details.dart';
import 'package:exif_toolkit/authentication/input_validator.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = AuthService();

  //Controllers
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordRetype = TextEditingController();

  //Error message variables
  String? _emailError;
  String? _passwordError;
  String? _passwordRetypeError;

  @override
  void initState() {
    super.initState();

    _email.addListener(_validateEmail);

    _password.addListener(_validatePassword);
    _passwordRetype.addListener(_validateRetype);
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  //Email validation
  void _validateEmail() {
    setState(() {
      _emailError = EmailValidator.validate(_email.text);
    });
  }

  //Password validation
  void _validatePassword() {
    setState(() {
      _passwordError = PasswordValidator.validate(_password.text);
    });
  }

  //Password retype validation
  void _validateRetype() {
    setState(() {
      _passwordRetypeError = RetypePasswordValidator.validate(
          _passwordRetype.text, _password.text);
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      errorText: _passwordError),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordRetype,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      errorText: _passwordRetypeError),
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
    final user = await _auth.createUserWithEmailAndPassword(
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
