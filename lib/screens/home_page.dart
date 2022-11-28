import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/firebase_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? res = ModalRoute.of(context)!.settings.arguments as User?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 70),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                (res!.photoURL == null)
                    ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                    : res.photoURL.toString(),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Name : ${(res.displayName == null) ? "--" : res.displayName}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              "Email : ${(res.email == null) ? "---" : res.email}",
              style: GoogleFonts.poppins(),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                FireBaseHelper.fireBaseHelper.singOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login_page", (route) => false);
              },
              child: Text(
                "Sign Out",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
