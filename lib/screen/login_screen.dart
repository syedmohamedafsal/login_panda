import 'dart:math';

import 'package:flutter/material.dart';
import 'package:login_animation/widgets/signup_form.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import '../rive/rive_controller.dart';
import '../widgets/login_form.dart';
import '../widgets/snow_widget.dart';

class LoginSignupFlipScreen extends StatefulWidget {
  const LoginSignupFlipScreen({super.key});

  @override
  State<LoginSignupFlipScreen> createState() => _LoginSignupFlipScreenState();
}

class _LoginSignupFlipScreenState extends State<LoginSignupFlipScreen> {
  final LoginMachineController riveController = LoginMachineController();
  bool showLogin = true;

  void _onRiveInit(Artboard artboard) {
    riveController.init(artboard);
  }

  void toggleCard() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Snow gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEAF6FF),
                  Color(0xFFD6ECFF),
                  Color.fromARGB(255, 237, 239, 241),
                ],
              ),
            ),
          ),

          /// ❄️ Snow falling and accumulated at bottom
          const SnowWidget(numberOfSnowflakes: 150),

          /// Polar bear Rive animation
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 400,
              child: RiveAnimation.asset(
                "assets/rive/login-machine.riv",
                stateMachines: const ["Login Machine"],
                onInit: _onRiveInit,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Flip Card Container
          Align(
            alignment: const Alignment(0, 0.4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation) {
                  final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                  return AnimatedBuilder(
                    animation: rotate,
                    child: child,
                    builder: (context, child) {
                      final isUnder = (ValueKey(showLogin) != child!.key);
                      var tilt = (animation.value - 0.5).abs() - 0.5;
                      tilt *= isUnder ? -0.003 : 0.003;
                      final value = rotate.value;
                      return Transform(
                        transform: Matrix4.rotationY(value)
                          ..setEntry(3, 0, tilt),
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                  );
                },
                child: showLogin
                    ? LoginForm(
                        key: const ValueKey(true),
                        controller: riveController,
                        toggleSignup: toggleCard, // pass callback
                      )
                    : SignupForm(
                        key: const ValueKey(false),
                        toggleLogin: toggleCard, // pass callback
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
