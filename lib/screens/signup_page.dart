import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global.dart';
import '../helper/firebase_helper.dart';
import '../widgets/button_style.dart';
import '../widgets/snackbar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? email;
  String? password;
  String? password2;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.clear();
    password2Controller.clear();
    emailController.clear();

    email = null;
    password = null;
    password2 = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Create an Account",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Global.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Image.asset("assets/images/signup.png"),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Email First..." : null;
                },
                onSaved: (val) {
                  email = val;
                },
                decoration: textFieldDecoration(
                  icon: Icons.email,
                  name: "Email",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Password First..." : null;
                },
                onSaved: (val) {
                  password = val;
                },
                obscureText: true,
                decoration: textFieldDecoration(
                  icon: Icons.password,
                  name: "Password",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password2Controller,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Password First..." : null;
                },
                onSaved: (val) {
                  password2 = val;
                },
                obscureText: true,
                decoration: textFieldDecoration(
                  icon: Icons.password,
                  name: "Conform Password",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      if (password == password2) {
                        User? user = await FireBaseHelper.fireBaseHelper
                            .singUp(email: email!, password: password!);
                        snackBar(
                            user: user,
                            context: context,
                            name: "Account Create");
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            content: Row(
                              children: [
                                const Icon(Icons.password, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  "Password Don't Match..",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                          ),
                        );
                        passwordController.clear();
                        password2Controller.clear();
                        password = null;
                        password2 = null;
                        formKey.currentState!.validate();
                      }
                    }
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                style: elevatedButtonStyle(),
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ? ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
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

  textFieldDecoration({required IconData icon, required String name}) {
    return InputDecoration(
      fillColor: Global.color.withOpacity(0.03),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      hintStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon),
      label: Text(
        name,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
      hintText: "Enter Your $name hear...",
    );
  }
}
