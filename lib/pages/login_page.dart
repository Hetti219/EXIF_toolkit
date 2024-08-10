import 'package:exif_toolkit/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void _showResetDeviceDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final ThemeData theme = Theme.of(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Reset Account Device',
              style: theme.textTheme.headlineMedium,
            ),
            content: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: theme.textTheme.labelMedium,
              decoration: const InputDecoration(labelText: 'Enter Email'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyMedium,
                  )),
              TextButton(
                  onPressed: () async {
                    String email = emailController.text.trim();

                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Account Device Reset Email sent.',
                        style: theme.textTheme.bodyMedium,
                      )));
                    } on FirebaseException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "User Email doesn't exist",
                          style: theme.textTheme.bodyMedium,
                        )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Error sending Account Device Reset email: ${e.message}',
                          style: theme.textTheme.bodyMedium,
                        )));
                      }
                    }
                  },
                  child: Text(
                    'Send Reset Link',
                    style: theme.textTheme.bodyMedium,
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Login', style: theme.textTheme.headlineMedium),
          centerTitle: true,
          //backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/Gemini_Generated_Image_exos46exos46exos.jpeg',
                  height: 200,
                  width: 200,
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
                      icon: const Icon(Icons.email),
                      labelText: 'Enter User Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Color(0xFF1877F2))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password),
                            labelText: 'Enter Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Color(0xFF1877F2))),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showResetDeviceDialog(context);
                          },
                          child: Text(
                            'Reset Account Device?',
                            style: theme.textTheme.labelSmall,
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20)),
                  child: Text(
                    'Login',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/signup_page');
                  },
                  child: Text(
                    'Are you a new user? Sign up here',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _login() async {
    try {
      final user = await _auth.loginUserWithEmailAndPassword(
          _email.text, _password.text);

      if (user != null) {
        if (await _auth.authenticateWithBiometrics()) {
          log("User Logged Successfully!");
          Navigator.pushReplacementNamed(context, '/home_page');
        }
      }
    } on FirebaseAuthException catch (e) {
      log("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login failed. Please check your credentials.')),
      );
    }
  }
}
