import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/custom_exceptions.dart';
import '../screens/main/home/homePage.dart';

class AuthClass extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? authTimer;
  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String? get userID {
    return _userId;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final storage = const FlutterSecureStorage();

  Stream<String?> get onAuthStateChanged =>
      _auth.authStateChanges().map((User? user) => user?.uid);

  Future<void> inputData() async {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
  }

  Future<void> googleSignIn(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) return; // user cancelled
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // ensure profile doc exists
      final uid = userCredential.user?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('profile')
            .doc(uid)
            .get();
        if (!doc.exists) {
          try {
            await FirebaseFirestore.instance
                .collection('profile')
                .doc(uid)
                .set({
              'userName': userCredential.user?.displayName,
              'email': userCredential.user?.email,
              'phoneNumber': userCredential.user?.phoneNumber ?? 'Not Set',
              'uid': uid,
              'picture': userCredential.user?.photoURL ??
                  'https://www.nicepng.com/ourpic/u2q8i1t4t4t4q8a9_group-of-10-guys-login-user-icon-png/',
              'weight': 'Not Set',
              'height': 'Not Set',
              'bloodPressure': 'Not Set',
              'bloodSugar': 'Not Set',
              'allergies': 'None',
              'bloodGroup': 'Not Set',
              'age': 'Not Set',
              'gender': 'Not Set',
            });
          } catch (e) {
            print(e.toString());
          }
        }
      }

      storeTokenAndData(userCredential);
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);
      final snackBar = SnackBar(
          content: Text(userCredential.user?.displayName ?? 'Signed in'));
      messenger.showSnackBar(snackBar);
    } catch (e) {
      print("here---->");
      final snackBar = SnackBar(content: Text(e.toString()));
      messenger.showSnackBar(snackBar);
    }
  }

  Future<void> signOut({BuildContext? context}) async {
    final messenger = context != null ? ScaffoldMessenger.of(context) : null;
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      if (messenger != null) {
        final snackBar = SnackBar(content: Text(e.toString()));
        messenger.showSnackBar(snackBar);
      }
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSeg?key=AIzaSyCw-YBHGinNHqpbZW74TpL511-s_p5KJQI';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('profile').get();
      final List<DocumentSnapshot> documents = result.docs;
      bool userExits = false;
      final currentUid = _auth.currentUser?.uid;
      for (var document in documents) {
        if (document.id == currentUid) userExits = true;
      }
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      if (!userExits) {
        prefs.setBool('first', true);
        try {
          await FirebaseFirestore.instance
              .collection('profile')
              .doc(_auth.currentUser?.uid.toString() ?? '')
              .set({
            'userName': _auth.currentUser?.displayName,
            'email': _auth.currentUser?.email,
            'phoneNumber': _auth.currentUser?.phoneNumber ?? 'Not Set ',
            'uid': _auth.currentUser?.uid,
            'picture': _auth.currentUser?.photoURL ??
                'https://www.nicepng.com/ourpic/u2q8i1t4t4t4q8a9_group-of-10-guys-login-user-icon-png/',
            'weight': 'Not Set',
            'height': 'Not Set',
            'bloodPressure': 'Not Set',
            'bloodSugar': 'Not Set',
            'allergies': 'None',
            'bloodGroup': 'Not Set',
            'age': 'Not Set',
            'gender': 'Not Set',
          });
        } catch (e) {
          print(e.toString());
        }
      }
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw CustomExceptions(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();

      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate?.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userDataString = prefs.getString('userData');
    if (userDataString == null) {
      return false; // No saved session
    }

    final extractedData = json.decode(userDataString) as Map<String, dynamic>;

    if (!extractedData.containsKey('expiryDate')) {
      return false; // Missing expiry date
    }

    final userExpiryDate = DateTime.tryParse(extractedData['expiryDate']);
    if (userExpiryDate == null || userExpiryDate.isBefore(DateTime.now())) {
      return false; // Expired or invalid date
    }
    return true; // Session still valid
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    authTimer?.cancel();
    authTimer = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    authTimer?.cancel();
    final expiryTime = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    authTimer = Timer(Duration(seconds: expiryTime), logout);
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    final messenger = ScaffoldMessenger.of(context);
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      messenger.showSnackBar(
          const SnackBar(content: Text("Verification Completed")));
    }

    verificationFailed(FirebaseAuthException exception) {
      messenger.showSnackBar(SnackBar(content: Text(exception.toString())));
    }

    codeSent(String verificationID, [int? forceResendingtoken]) {
      messenger.showSnackBar(const SnackBar(
          content: Text("Verification Code sent on the phone number")));
      setData(verificationID);
    }

    codeAutoRetrievalTimeout(String verificationID) {
      messenger.showSnackBar(const SnackBar(content: Text("Time out")));
    }

    try {
      await _auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);

      messenger.showSnackBar(const SnackBar(content: Text("Logged In")));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
