import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_mechanism/widgets/button_style.dart';

import '../global.dart';
import '../helper/firebase_helper.dart';
import '../widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? email;
  String? password;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.clear();
    emailController.clear();

    email = null;
    password = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Image.asset("assets/images/signin.png"),
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
              ElevatedButton(
                onPressed: () async {
                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      User? user = await FireBaseHelper.fireBaseHelper
                          .singIn(email: email!, password: password!);
                      snackBar(user: user, context: context, name: "Sing In");
                    }
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                style: elevatedButtonStyle(),
                child: const Text("Sing in"),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ? ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("signup_page");
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 2),
              const SizedBox(height: 15),
              InkWell(
                splashColor: Global.color,
                borderRadius: BorderRadius.circular(100),
                onTap: () async {
                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    User? user =
                        await FireBaseHelper.fireBaseHelper.signInWithGoogle();
                    snackBar(user: user, context: context, name: "Login");
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                child: Ink(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Global.color, width: 1.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://play-lh.googleusercontent.com/6UgEjh8Xuts4nwdWzTnWH8QtLuHqRMUB7dp24JYVE2xcYzq4HA8hFfcAbU-R-PC_9uA1"),
                          radius: 25,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Continue with Google",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                splashColor: Global.color,
                borderRadius: BorderRadius.circular(100),
                onTap: () async {
                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    User? user =
                        await FireBaseHelper.fireBaseHelper.signInAnonymously();

                    snackBar(user: user, context: context, name: "Login");
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                child: Ink(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Global.color, width: 1.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Continue as Guest",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
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
