import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String message = "";
  bool isError = false;

  bool isObscureNew = true;
  bool isObscureConfirm = true;

  void clearError(String value) {
    if (message.isNotEmpty) {
      setState(() {
        message = "";
        isError = false;
      });
    }
  }

  void handleUpdatePassword() {
    String email = emailController.text.trim();
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        message = "All fields are required.";
        isError = true;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        message = "Passwords do not match.";
        isError = true;
      });
      return;
    }

    if (newPassword.length < 8) {
      setState(() {
        message = "Password must be at least 8 characters long.";
        isError = true;
      });
      return;
    }

    bool hasUpper = false;
    bool hasLower = false;
    bool hasDigit = false;
    bool hasSpecial = false;

    String upperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String lowerLetters = "abcdefghijklmnopqrstuvwxyz";
    String numbers = "0123456789";

    for (int i = 0; i < newPassword.length; i++) {
      String char = newPassword[i];
      if (upperLetters.contains(char)) {
        hasUpper = true;
      } else if (lowerLetters.contains(char)) {
        hasLower = true;
      } else if (numbers.contains(char)) {
        hasDigit = true;
      } else if (char != ' ') {
        hasSpecial = true;
      }
    }

    if (!hasUpper || !hasLower || !hasDigit || !hasSpecial) {
      setState(() {
        message =
            "Password needs uppercase, lowercase, number, and special char.";
        isError = true;
      });
      return;
    }

    for (var i = 0; i < MockDatabase.users.length; i++) {
      if (MockDatabase.users[i]["email"] == email) {
        if (MockDatabase.users[i]["password"] == newPassword) {
          setState(() {
            message =
                "New password cannot be the same as the existing password.";
            isError = true;
          });
          return;
        }

        MockDatabase.users[i]["password"] = newPassword;

        setState(() {
          message = "";
          isError = false;
        });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Success",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Password successfully updated! Redirecting to login...",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        });
        return;
      }
    }

    setState(() {
      message = "Email not found.";
      isError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/RegisBg.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 25,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 75,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enter Email", style: TextStyle(fontSize: 20)),
                      TextField(
                        controller: emailController,
                        onChanged: clearError,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "New Password",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        controller: newPasswordController,
                        obscureText: isObscureNew,
                        onChanged: clearError,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscureNew
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => isObscureNew = !isObscureNew),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Retype New Password",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: isObscureConfirm,
                        onChanged: clearError,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => isObscureConfirm = !isObscureConfirm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (message.isNotEmpty)
                        Text(
                          message,
                          style: TextStyle(
                            color: isError ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 60),
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: handleUpdatePassword,
                        child: const Text(
                          "Update Password",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
