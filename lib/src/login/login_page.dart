import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center (
        child: Text('Fast Food Delivery - Lomi Chef'),
      ),
    );
  } //el build es el código que corre en la pantalla
}
