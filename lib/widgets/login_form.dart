import 'package:flutter/material.dart';
import 'package:login_animation/widgets/custom_textfeild.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../rive/rive_controller.dart';

class LoginForm extends StatefulWidget {
  final LoginMachineController controller;
  final VoidCallback toggleSignup;

  const LoginForm({
    super.key,
    required this.controller,
    required this.toggleSignup,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (isSubmitting) return;

      if (emailFocus.hasFocus) {
        widget.controller.startChecking();
      } else {
        widget.controller.stopChecking();
      }
    });

    passwordFocus.addListener(() {
      if (isSubmitting) return;

      if (passwordFocus.hasFocus) {
        widget.controller.handsUp();
      }
    });
  }

  void togglePassword() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
      if (isPasswordVisible) {
        widget.controller.startChecking();
      } else {
        widget.controller.handsUp();
      }
    });
  }

  void login() {
    print("LOGIN BUTTON PRESSED");

    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    String email = emailController.text;
    String password = passwordController.text;

    // Force hands down first
    widget.controller.stopChecking();
    widget.controller.handsDown();

    // Wait for animation to finish
    Future.delayed(const Duration(milliseconds: 400), () {
      if (email == "admin@gmail.com" && password == "123456") {
        print("SUCCESS TRIGGER");
        widget.controller.success();
      } else {
        print("FAIL TRIGGER");
        widget.controller.fail();
      }
    });
  }

  // ❄️ Social login button
  Widget socialButton(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92), // snow-like background
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: Icon(icon, color: color)),
    );
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
              // Fade in title
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Email
              CustomTextField(
                label: "Email",
                prefixIcon: Icons.email,
                controller: emailController,
                focusNode: emailFocus,
                onChanged: (val) =>
                    widget.controller.moveEyes(val.length.toDouble()),
              ),
              const SizedBox(height: 20),

              // Password
              CustomTextField(
                label: "Password",
                prefixIcon: Icons.lock,
                controller: passwordController,
                focusNode: passwordFocus,
                obscureText: !isPasswordVisible,
                // suffixIcon: IconButton(
                //   icon: Icon(
                //     isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                //     color: const Color.fromARGB(255, 128, 20, 20),
                //   ),
                //   onPressed: togglePassword,
                // ),
              ),
              const SizedBox(height: 30),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 20, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "LOGIN",
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

              // ❄️ Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialButton(FontAwesomeIcons.google, Colors.red),
                  const SizedBox(width: 20),
                  socialButton(FontAwesomeIcons.facebookF, Colors.blue),
                  const SizedBox(width: 20),
                  socialButton(FontAwesomeIcons.apple, Colors.black),
                ],
              ),
              const SizedBox(height: 20),

              // Toggle signup
              GestureDetector(
                onTap: widget.toggleSignup,
                child: const Text(
                  "Don't have an account? Create it",
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
