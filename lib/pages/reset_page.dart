import 'package:chat_apps_bac/pages/login_page.dart';
import 'package:chat_apps_bac/widgets/my_button.dart';
import 'package:chat_apps_bac/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPage extends StatelessWidget {
  ResetPage({
    super.key,
  });

  final resetPasswordController = TextEditingController();
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;

  void resetButton(context) async {
     _firebaseAuth.sendPasswordResetEmail(email: resetPasswordController.text).then((value) {
   Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const LoginPage())));
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Icon(
              Icons.android_outlined,
              size: 150,
            ),
            MyTextField(
              textFieldText: "Reset Password",
              controller: resetPasswordController,
              obscureText: false,
            ),
            const SizedBox(
              height: 5,
            ),
            MyButton(
              buttonText: "Reset",
              onTap: () => resetButton(context),
            ),
          ],
        ),
      ),
    );
  }
}
