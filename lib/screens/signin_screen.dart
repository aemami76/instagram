import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_meth.dart';
import 'package:instagram_flutter/resources/getUserModel.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pController = TextEditingController();
  final _eController = TextEditingController();
  bool _isLoading = false;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String res = await AuthMeth()
          .signIn(email: _eController.text, pass: _pController.text);

      if (res.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error >>> $res"),
          backgroundColor: Colors.red,
        ));
      }

      GetUserModel().setUserModel();

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pController.dispose();
    _eController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
              ),
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
                  if (!(val.contains('@') || val.contains('.')) ||
                      val.length <= 6) {
                    return 'Wrong syntax';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                  controller: _pController,
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
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: const Text('Sign in'))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
                  },
                  child: const Text('I don\'t have an account, Sign up.')),
            ],
          ),
        ),
      ),
    );
  }
}
