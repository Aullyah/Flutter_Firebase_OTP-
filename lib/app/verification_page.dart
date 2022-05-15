import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPage extends StatefulWidget {
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController txtVerificationCode = TextEditingController(text: "");
  TextEditingController txtSmsCode = TextEditingController(text: "");

  void getVerificationCode() async {
    SharedPreferences pref = await _prefs;
    txtVerificationCode.text = pref.getString('verificationID').toString();
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: txtVerificationCode.text, smsCode: txtSmsCode.text);
    try {
      var verifyCredential = await auth.signInWithCredential(credential);
      if (verifyCredential != null) {
        final snackBar = SnackBar(
          content: const Text(
            'Success login',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (Colors.white),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Verification",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "The verification code has been sent by email to test@gmail.com",
                  style: TextStyle(color: Colors.white, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      // print(value);
                      // print(txtVerificationCode.text);
                    },
                    controller: txtSmsCode,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
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
                        onPressed: () => verifyOTP(),
                        child: Text("Next")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
