import 'package:authentication_integration_codeclause/display_screens/homepage.dart';
import 'package:authentication_integration_codeclause/display_screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});
  static String verifyId = "";
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  var phoneEditor = "";
  final TextEditingController countryCode = TextEditingController();
  Map<String, dynamic>? _userData;
  @override
  void initState() {
    countryCode.text = '+91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade700,
        elevation: 2,
        automaticallyImplyLeading: false,
        titleSpacing: 50,
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        title: const Text('Authentication Integration'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, top: 100),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/intro_img.png', width: 200, height: 200),
              const SizedBox(height: 40),
              const SizedBox(
                  height: 30,
                  child: Text('Phone Verification',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
              const Text('Enter contact number to receive otp!',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 42,
                        child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: countryCode,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            style: const TextStyle(fontSize: 20))),
                    const SizedBox(
                        width: 10,
                        child: Text('|',
                            style:
                                TextStyle(fontSize: 40, color: Colors.grey))),
                    const SizedBox(width: 5),
                    Expanded(
                        child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              phoneEditor = value;
                            },
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter mobile no.'))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: countryCode.text + phoneEditor,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {
                        Fluttertoast.showToast(msg: 'Error in verification');
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        loginPage.verifyId = verificationId;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => otpClass()));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Send Otp',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.green,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Or continue with',
                        style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.6,
                    color: Colors.green,
                  )),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await signInWithGoogle();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const homePage()));
                        },
                        icon: Image.asset('assets/google.png',
                            height: 80, width: 80)),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await signInWithGoogle();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const homePage()));
                        },
                        icon: Image.asset('assets/facebook.png',
                            height: 80, width: 80)),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await signInWithGitHub();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const homePage()));
                        },
                        icon: Image.asset('assets/github.png',
                            height: 90, width: 90)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  Future<UserCredential> signInWithGitHub() async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: '306f9edf14b82671c18a',
        clientSecret: 'c8a26910b05014ace2f8316c081fa48f8040c9ce',
        redirectUrl:
            "https://authentication-integrati-9c4bc.firebaseapp.com/__/auth/handler");
    final result = await gitHubSignIn.signIn(context);
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);
    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }
}
