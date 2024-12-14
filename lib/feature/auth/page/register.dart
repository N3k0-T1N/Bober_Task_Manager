import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_state.dart';
import '../cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:bober_task_manager/feature/task/page/task_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String route = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthorized) {
          context.go(TasksPage.route);
        } else if (state is AuthUnauthorized && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go(LoginPage.route),
          ),
          backgroundColor: const Color.fromARGB(255, 184, 134, 11),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 175,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 134, 11),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 5,
                      ),
                    ],
                    border: Border.all(color: Colors.brown, width: 2),
                  ),
                  child: const Text(
                    'Bober Task Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _buildSquareTextField(
                controller: _emailController,
                hintText: 'Email',
              ),
              const SizedBox(height: 16),
              _buildSquareTextField(
                controller: _passwordController,
                hintText: 'Пароль',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildSquareTextField(
                controller: _confirmPasswordController,
                hintText: 'Подтвердите пароль',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return _buildWoodenButton(
                    label: state is AuthLoading
                        ? 'Загрузка...'
                        : 'Зарегистрироваться',
                    onPressed: state is AuthLoading
                        ? null
                        : () => _handleRegister(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 184, 134, 11),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.5),

                  offset: const Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
              border: Border.all(color: Colors.brown, width: 2),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWoodenButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 184, 134, 11),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
        border: Border.all(color: Colors.brown, width: 2),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароли не совпадают')),
      );
      return;
    }

    context.read<AuthCubit>().signUpWithEmail(email, password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
