import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nickys_crochet_designs/presentation/resources/asset_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/color_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/route_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/string_manager.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';
import 'package:nickys_crochet_designs/utilities/palette.dart';

class Login extends StatelessWidget {
  Login({Key key}) : super(key: key);

  final _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: ColorPalette.colorPalette.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * SizeManager.s0_03,
            ),
            CircleAvatar(
              backgroundImage: const AssetImage(
                AssetManager.logo,
              ),
              radius: size.width * RadiusManager.r0_13,
            ),
            SizedBox(
              height: size.height * SizeManager.s0_05,
            ),
            LoginTextField(controller: _email, label: StringManager.email),
            SizedBox(
              height: size.height * SizeManager.s0_01,
            ),
            LoginTextField(
                controller: _password, label: StringManager.password),
            SizedBox(
              height: size.height * SizeManager.s0_03,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                  await _firebaseAuth.signInWithEmailAndPassword(
                    email: _email.text,
                    password: _password.text,
                  );

                  User user = userCredential.user;

                  if (user != null) {
                    Navigator.pushNamed(
                      context,
                      Routes.home,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.code,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: ElevationManager.e_3,
                foregroundColor: ColorManager.white70,
                backgroundColor: ColorPalette.colorPalette.shade600,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * SizeManager.s0_3,
                  vertical: size.height * SizeManager.s0_035,
                ),
              ),
              child: const Text(
                StringManager.signIn,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    Key key,
    @required this.controller,
    @required this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SizedBox(
      width: size.width * SizeManager.s0_8,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(
            label,
          ),
          floatingLabelStyle: TextStyle(
            color: ColorPalette.colorPalette.shade500,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
