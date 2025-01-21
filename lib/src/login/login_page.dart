
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/login/login_controller.dart';
import '../utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _controllerLogin = LoginController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controllerLogin.init(context);     //metodo para inicializar controladores
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 32),
              _buildWelcomeText(),
              const SizedBox(height: 32),
              _buildEmailTextField(),
              const SizedBox(height: 16),
              _buildPasswordTextField(),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildForgotPasswordButton(),
              const SizedBox(height: 16),
              _buildRegisterPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Login',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildLogo() {
    return const CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage('assets/img/logo.png'),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: const [
        Text(
          'Bienvenido a Lomi Chef',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Por favor, ingresá a tu cuenta para continuar',
          style: TextStyle(fontSize: 16, color: AppColors.secondaryTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: _controllerLogin.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        hintText: 'Ingresá tu correo',
        prefixIcon: const Icon(Icons.email, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _controllerLogin.passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Ingresá tu contraseña',
        prefixIcon: const Icon(Icons.lock, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _controllerLogin.login();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Ingresar',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // TODO
      },
      child: const Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.secondaryTextColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿No tenés cuenta? ',
          style: TextStyle(fontSize: 14, color: AppColors.secondaryTextColor),
        ),
        GestureDetector(
          onTap: _controllerLogin.goToRegisterPage,
          child: const Text(
            'Registrate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
