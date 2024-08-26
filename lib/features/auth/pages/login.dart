import 'package:ecommerce/features/_global/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ecommerce/core/services/auth.dart';
import 'package:ecommerce/features/dashboard/pages/home.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    final authService = AuthService();

    Future<void> login() async {
      isLoading.value = true;

      String email = emailController.text;
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email dan Password harus diisi')),
        );
        isLoading.value = false;
        return;
      }

      var result = await authService.fetchLogin(email, password);

      if (!context.mounted) return;
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!')),
        );

        Navigator.of(context)
            .pushReplacement(SlideScaleTransition(page: HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${result['message']}')),
        );
      }

      isLoading.value = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ecoms Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: "Enter your email"),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: Text('Login'),
                    ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
