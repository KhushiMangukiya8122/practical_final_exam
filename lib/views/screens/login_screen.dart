import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/firebase_auth_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final TextEditingController emailSignInController = TextEditingController();
  final TextEditingController passwordSignInController =
      TextEditingController();

  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  String? signInemail;
  String? signInpassword;

  String? signUpemail;
  String? signUppassword;
  String? signUpConfirmPassword;

  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: initialIndex,
        children: [
          //sign in
          Column(
            children: [
              Container(
                height: 300,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                      35,
                    ),
                  ),
                ),
              ),
              Text(
                "Log in",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: signInFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: TextFormField(
                        onSaved: (val) {
                          signInemail = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              size: 30,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            border: const OutlineInputBorder(),
                            hintText: "Your Email/User Name",
                            hintStyle: TextStyle(
                              fontSize: 18,
                            )),
                        controller: emailSignInController,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: TextFormField(
                        controller: passwordSignInController,
                        onSaved: (val) {
                          signInpassword = val;
                        },
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter a Password" : null,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.password,
                            size: 30,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        initialIndex = 1;
                      });
                    },
                    child: Text(
                      "Create New",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (signInFormKey.currentState!.validate()) {
                        signInFormKey.currentState!.save();

                        Map<String, dynamic> data = await FirebaseAuthHelper
                            .firebaseAuthHelper
                            .signinWithEmailPassword(
                          email: signInemail!,
                          password: signInpassword!,
                        );

                        if (data['user'] != null) {
                          Get.snackbar(
                            "Success",
                            "SignIn Successfully...",
                            backgroundColor: Colors.green,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.offNamed(
                            "/home_page",
                            arguments: data['user'],
                          );
                          emailSignInController.clear();
                          passwordSignInController.clear();
                        } else {
                          Get.snackbar(
                            "Failed",
                            data['msg'],
                            backgroundColor: Colors.redAccent,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                    child: Text(
                      "login",
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuthHelper.firebaseAuthHelper.signInWithGoogle();
                },
                child: Text(
                  "google",
                ),
              ),
            ],
          ),

          //sign up
          Column(
            children: [
              Container(
                height: 300,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                      35,
                    ),
                  ),
                ),
              ),
              Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: signUpFormKey,
                child: Column(
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: TextFormField(
                        onSaved: (val) {
                          signUpemail = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            size: 30,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: "Your Email",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        controller: emailSignUpController,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: TextFormField(
                        controller: passwordSignUpController,
                        onSaved: (val) {
                          signUppassword = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.password,
                            size: 30,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: TextFormField(
                        controller: signUpConfirmPasswordController,
                        onSaved: (val) {
                          signUpConfirmPassword = val;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.password,
                            size: 30,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (signUpFormKey.currentState!.validate()) {
                        signUpFormKey.currentState!.save();
                        if (signUppassword != signUpConfirmPassword) {
                          Get.snackbar(
                            "Failed",
                            "Password and Confirm password not match..",
                            backgroundColor: Colors.redAccent,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Map<String, dynamic> data = await FirebaseAuthHelper
                              .firebaseAuthHelper
                              .signupWithEmailPassword(
                                  email: signUpemail!,
                                  password: signUppassword!);

                          if (data['user'] != null) {
                            Get.snackbar(
                              "Success",
                              "SignUp Successfully...",
                              backgroundColor: Colors.green,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            initialIndex = 0;
                            emailSignUpController.clear();
                            passwordSignUpController.clear();
                            setState(() {});
                          } else {
                            Get.snackbar(
                              "Failed",
                              data['msg'],
                              backgroundColor: Colors.redAccent,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        }
                      }
                      initialIndex = 0;
                    },
                    child: Text(
                      "Sign Up",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
