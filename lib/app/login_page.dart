import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtPhoneNumber = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(177, 0, 255, 102), Color(0xFF05A2E6)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: txtPhoneNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, .7),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                    ),
                    hintText: 'phone number...',
                    hintStyle: TextStyle(color: Colors.black45),
                    suffixIcon: Icon(
                      Icons.close,
                      size: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: double.maxFinite,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () => login(),
                        child: Text("Next")))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    SharedPreferences pref = await _prefs;
    try {
      auth.verifyPhoneNumber(
          phoneNumber: txtPhoneNumber.text,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException err) {
            print(err.message);
          },
          codeSent: (String verifiactionID, int? resendToken) {
            pref.setString('verificationID', verifiactionID);
            setState(() {
              var verificationID = pref.getString('verificationID');
              if (verificationID != null || verificationID != '') {
                print('verificationID : $verificationID');
              }
            });
          },
          codeAutoRetrievalTimeout: (String e) {
            print("codeAutoRetrievalTimeout : $e");
          });
    } catch (e) {
      print(e.toString());
    } finally {
      Navigator.pushNamed(context, '/verification');
    }
  }
}
