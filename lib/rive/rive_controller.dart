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

      // Debug: List all available inputs to find hidden names
      for (var input in controller!.inputs) {
        print("RIVE INPUT FOUND: ${input.name} (Type: ${input.runtimeType})");
      }

      trigSuccess = controller!.findSMI("trigSuccess");
      trigFail = controller!.findSMI("trigFail");

      print("Rive Controller Setup Complete");
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
    print("RESET STATES (FORCED)");
    isChecking?.value = false;
    isHandsUp?.value = false;
    numLook?.value = 0.0;
  }

  void success() {
    print("RIVE SUCCESS TRIGGER CALLED");
    _continuousFire(trigSuccess);
  }

  void fail() {
    print("RIVE FAIL TRIGGER CALLED");
    _continuousFire(trigFail);
  }

  void _continuousFire(SMITrigger? trigger) {
    if (trigger == null) return;

    // Fire immediately and then every 200ms for a second to ensure it's caught
    // even during complex state machine transitions or keyboard dismissal.
    for (int i = 0; i < 6; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        // Hammer the inputs to false to ensure we are in Idle
        isChecking?.value = false;
        isHandsUp?.value = false;
        numLook?.value = 0.0;
        
        trigger.fire();
        if (i == 5) print("TRIGGER CONTINUOUS FIRE FINISHED");
      });
    }
  }

  void moveEyes(double value) {
    // Only move if not in middle of a result or submission
    if (isChecking?.value == true) {
      numLook?.change(value);
    }
  }
}
