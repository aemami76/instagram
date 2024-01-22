import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/image_picker_widget.dart';

import '../resources/auth_meth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? profilePicture;
  void getProfilePicture(Uint8List? value) => profilePicture = value;

  final _p1Controller = TextEditingController();
  final _p2Controller = TextEditingController();
  final _uController = TextEditingController();
  final _eController = TextEditingController();
  final _bController = TextEditingController();

  bool _isLoading = false;

  void _signUp() async {
    if (profilePicture == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Choose a profile Picture"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String res = await AuthMeth().signUp(
          email: _eController.text,
          pass: _p1Controller.text,
          username: _uController.text,
          bio: _bController.text,
          file: profilePicture!);

      if (res.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error >>> $res"),
          backgroundColor: Colors.red,
        ));
      }

      setState(() {
        _isLoading = false;
      });

      if (res.isEmpty && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    _uController.dispose();
    _eController.dispose();
    _bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Hero(
                tag: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/instagramLogo.png',
                      height: 50,
                    ),
                    Image.asset(
                      'assets/instagramText.png',
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              ImagePickerWidget(getProfilePicture),
              const SizedBox(height: 20),

              /// Username
              TextFormField(
                controller: _uController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.black12,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  border: OutlineInputBorder(
                      borderSide:
                          Divider.createBorderSide(context, color: Colors.red),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                ),
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),

              /// bio
              TextFormField(
                controller: _bController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'bio',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.black12,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  border: OutlineInputBorder(
                      borderSide:
                          Divider.createBorderSide(context, color: Colors.red),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                ),
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),

              ///Email
              TextFormField(
                controller: _eController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'email',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.black12,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  border: OutlineInputBorder(
                      borderSide:
                          Divider.createBorderSide(context, color: Colors.red),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  if (!(val.contains('@') && val.contains('.')) &&
                      val.length <= 6) {
                    return 'Wrong syntax';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),

              ///Password
              TextFormField(
                  controller: _p1Controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'password',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context,
                            color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Required';
                    }
                    if (val.length <= 6) {
                      return 'Password should have more than 6 characters.';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(height: 20),

              /// Confirm password
              TextFormField(
                  controller: _p2Controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'confirm your password',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context,
                            color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (val) {
                    if (val != _p1Controller.text) {
                      return 'passwords are different.';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(height: 20),

              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      child: const Text('Sign Up'))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('I already have an account, Sign In.')),
            ],
          ),
        ),
      ),
    );
  }
}
