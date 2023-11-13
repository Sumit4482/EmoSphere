import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_button.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passowordController = TextEditingController();

  final TextEditingController confirmPwController = TextEditingController();

  //register method
  void registerUser() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //make sure passwords and confpW match
    if (passowordController.text != confirmPwController.text) {
      //pop loading circle and show error
      Navigator.of(context);

      displayMessageToUser("Passwords don't match", context);
    } else {
      try {
        //create a user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passowordController.text);

        //create a user document and add to firestore

        createUserDocument(userCredential);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        //pop loading circle
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }

    //try creating the user
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.person_2_sharp,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 25),

                //app name
                const Text(
                  "E m o S p h e r e",
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 25),
                //username textfield
                MyTextField(
                  hintText: "Username",
                  obsecureText: false,
                  controller: usernameController,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Email",
                  obsecureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 10),
                //password textfield
                MyTextField(
                  hintText: "Password",
                  obsecureText: true,
                  controller: passowordController,
                ),
                //forgot passoword
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Confirm Password",
                  obsecureText: true,
                  controller: confirmPwController,
                ),
                //forgot passoword
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Passsword ?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                //sign in button
                MyButton(text: "Register", onTap: registerUser),

                const SizedBox(height: 25),
                //don't have an account sign in here

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
