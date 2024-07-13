import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();

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
                    style: theme.textTheme.labelLarge,
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
                    style: theme.textTheme.labelLarge,
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
          title: Text('Login', style: theme.textTheme.headlineLarge),
          centerTitle: true,
          backgroundColor: theme.colorScheme.primary,
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Enter User Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ))),
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
                  onPressed: () {},
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
                    Navigator.pushNamed(context, '/signup_page');
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
}
