import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/authenticate/register.dart';
import 'package:roro_medicine_reminder/screens/authenticate/signin.dart';
import 'package:roro_medicine_reminder/screens/main/Settings/settings.dart';

import '../../../widgets/size_config.dart';



class changePwd extends StatefulWidget {
  const changePwd({Key? key}) : super(key: key);

  @override
  State<changePwd> createState() => _changePwdState();
}

class _changePwdState extends State<changePwd> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The code for initialization was sent to you.',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SignInPage();
          },
        ),
      );
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        print('User not found!');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'User not exist!',
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
        ),
        actions: const [],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset( "assets/images/roroicon.png",
              height: SizeConfig.blockV * 35,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: const Text(
              'A reset link will be sent to your email.',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          autofocus: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email.';
                            } else if (!value.contains('@')) {
                              return 'Enter a correct email address!';
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() {
                                    email = emailController.text;
                                  });
                                  resetPassword();
                                }
                              },
                              child: const Text('Send Email', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const SettingsPage();
                                    },
                                  ),
                                );
                              },
                              child: const Text('Cancel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => const SignUpPage()),
                                        (route) => false);
                              },
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
