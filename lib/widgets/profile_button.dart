import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton(this.function, this.color, this.string, {super.key});
  final Function()? function;
  final Color color;
  final String string;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      height: 30,
      width: 130,
      child: ElevatedButton(
        onPressed: function,
        child: Text(string),
        style: ElevatedButton.styleFrom(backgroundColor: color),
      ),
    );
  }
}
