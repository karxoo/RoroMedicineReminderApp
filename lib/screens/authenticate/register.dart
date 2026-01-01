import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roro_medicine_reminder/screens/authenticate/signin.dart';
import '../../services/auth.dart';
import '../main/home/homePage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;

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
                "SIGN UP",
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
                  () async {
                final auth = Provider.of<AuthClass>(context, listen: false);
                await auth.googleSignIn(context);
              }),
              const SizedBox(
                height: 15,
              ),
              buttonItem(
                  "assets/images/phone.svg", "Continue with Mobile", 30, () {}),
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
                    "If you already have an Account? ",
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
                          MaterialPageRoute(builder: (builder) => const SignInPage()),
                          (route) => false);
                    },
                    child: const Text(
                      "Login",
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
          await auth.signUp(_emailController.text.trim(), _pwdController.text);
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
                  "SIGN UP",
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
        style: const TextStyle(
          fontSize: 17,
          color: Colors.blueGrey,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.blueGrey,
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
