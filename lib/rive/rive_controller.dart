import 'package:rive/rive.dart';

class LoginMachineController {
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<double>? numLook;

  SMITrigger? trigSuccess;
  SMITrigger? trigFail;

  void init(Artboard artboard) {
    controller = StateMachineController.fromArtboard(artboard, "Login Machine");

    if (controller != null) {
      artboard.addController(controller!);

      isChecking = controller!.findInput<bool>("isChecking");
      isHandsUp = controller!.findInput<bool>("isHandsUp");
      numLook = controller!.findInput<double>("numLook");

      trigSuccess = controller!.findInput<bool>("trigSuccess") as SMITrigger?;
      trigFail = controller!.findInput<bool>("trigFail") as SMITrigger?;
    }
  }

  void startChecking() {
    print("START CHECKING");
    isHandsUp?.change(false);
    isChecking?.change(true);
  }

  void stopChecking() {
    print("STOP CHECKING");
    isChecking?.change(false);
  }

  void handsDown() {
    print("HANDS DOWN");
    isHandsUp?.change(false);
  }

  void handsUp() {
    print("HANDS UP");
    isChecking?.change(false);
    isHandsUp?.change(true);
  }

  void reset() {
    print("RESET STATES");
    isChecking?.change(false);
    isHandsUp?.change(false);
  }

  void success() {
    print("RIVE SUCCESS TRIGGER CALLED");

    isChecking?.change(false);
    isHandsUp?.change(false);

    Future.delayed(const Duration(milliseconds: 100), () {
      trigSuccess?.fire();
    });
  }

  void fail() {
    print("RIVE FAIL TRIGGER CALLED");

    // reset states first
    isChecking?.change(false);
    isHandsUp?.change(false);

    // small delay so Rive can return to Idle
    Future.delayed(const Duration(milliseconds: 100), () {
      print("FAIL TRIGGER FIRED");
      trigFail?.fire();
    });
  }

  void moveEyes(double value) {
    numLook?.change(value);
  }
}
