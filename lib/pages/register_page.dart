import 'package:chat_apps_bac/pages/list_page.dart';
import 'package:chat_apps_bac/pages/login_page.dart';
import 'package:chat_apps_bac/widgets/my_button.dart';
import 'package:chat_apps_bac/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> registerUser(String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailController.text,
  //       password: passwordController.text,
  //     );
  //      await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'email': emailController.text,
  //       // Add other user-specific data as needed
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //       ("Email already registered"),
  //     )));
  //   }
  // }

  void registerButton() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      // After user registration, create a Firestore document for the user
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        
        // Add other user-specific data as needed
      }).then((value) => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => const ListPage()),
              ),
            )
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        ("Login Failed"),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.android_outlined,
              size: 150,
            ),
            MyTextField(
              textFieldText: "Email",
              controller: emailController,
              obscureText: false,
            ),
            const SizedBox(
              height: 5,
            ),
            MyTextField(
              textFieldText: "Password",
              controller: passwordController,
              obscureText: false,
            ),
            const SizedBox(
              height: 5,
            ),
            MyButton(
              buttonText: "Register",
              onTap: () => registerButton(),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have account?",
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const LoginPage())));
                  },
                  child: const Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
