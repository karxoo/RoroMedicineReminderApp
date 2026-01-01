import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roro_medicine_reminder/screens/authenticate/forgotPwd.dart';
import 'package:roro_medicine_reminder/screens/authenticate/register.dart';
import 'package:roro_medicine_reminder/services/auth.dart';

import '../main/home/homePage.dart';
import 'PhoneAuth.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/SignInPage';

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffe3f1f4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SIGN IN",
                style: TextStyle(
                  fontFamily: "Mulish",
                  fontSize: 35,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buttonItem("assets/images/google.svg", "Continue with Google", 25,
                  () {
                final auth = Provider.of<AuthClass>(context, listen: false);
                auth.googleSignIn(context);
              }),
              const SizedBox(
                height: 15,
              ),
              buttonItem("assets/images/phone.svg", "Continue with Mobile", 30,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => const PhoneAuthPage()));
              }),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "OR",
                style: TextStyle(
                    fontFamily: "Mulish", color: Colors.blueGrey, fontSize: 18),
              ),
              const SizedBox(
                height: 18,
              ),
              textItem("Your Email", _emailController, false),
              const SizedBox(
                height: 15,
              ),
              textItem("Your Password", _pwdController, true),
              const SizedBox(
                height: 40,
              ),
              colorButton(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account? ",
                    style: TextStyle(
                      fontFamily: "Mulish",
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => const SignUpPage()),
                          (route) => false);
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                        fontFamily: "Mulish",
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => const forgotPwd()),
                      (route) => false);
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        final auth = Provider.of<AuthClass>(context, listen: false);
        try {
          await auth.signIn(_emailController.text.trim(), _pwdController.text);
          setState(() {
            circular = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xffff9987),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 17,
          color: Colors.blueGrey[900],
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.blueGrey[900],
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
