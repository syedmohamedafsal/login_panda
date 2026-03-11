import 'package:flutter/material.dart';
import 'package:login_animation/widgets/custom_textfeild.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback toggleLogin;

  const SignupForm({super.key, required this.toggleLogin});
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  void togglePassword() {
    setState(() => isPasswordVisible = !isPasswordVisible);
  }

  void signup() {
    if (!formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Signup Successful")));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      elevation: 18,
      shadowColor: Colors.blue.withOpacity(0.2),
      color: Colors.white.withOpacity(0.92),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create An Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up to get started",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: "Username",
                prefixIcon: Icons.person,
                controller: usernameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Email",
                prefixIcon: Icons.email,
                controller: emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Password",
                prefixIcon: Icons.lock,
                controller: passwordController,
                obscureText: !isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 128, 20, 20),
                  ),
                  onPressed: togglePassword,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 20, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: widget.toggleLogin,
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Color.fromARGB(255, 128, 20, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
