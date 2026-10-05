import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String message = "";
  bool isError = false;

  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  // FIXED: Helper function to clear errors when the user starts typing/deleting
  void _clearError(String value) {
    if (message.isNotEmpty) {
      setState(() {
        message = "";
        isError = false;
      });
    }
  }

  void _handleUpdatePassword() {
    String email = _emailController.text.trim();
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() { message = "All fields are required."; isError = true; });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() { message = "Passwords do not match."; isError = true; });
      return;
    }

    if (newPassword.length < 8) {
      setState(() { message = "Password must be at least 8 characters long."; isError = true; });
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
      setState(() { message = "Password needs uppercase, lowercase, number, and special char."; isError = true; });
      return;
    }

    for (var i = 0; i < MockDatabase.users.length; i++) {
      if (MockDatabase.users[i]["email"] == email) {
        
        if (MockDatabase.users[i]["password"] == newPassword) {
          setState(() { message = "New password cannot be the same as the existing password."; isError = true; });
          return;
        }

        MockDatabase.users[i]["password"] = newPassword;
        
        setState(() { message = ""; isError = false; });
        
        // Use a Dialog for the success message to match the register screen
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Success", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            content: Text("Password successfully updated! Redirecting to login...", style: TextStyle(fontSize: 16)),
          ),
        );
        
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Navigate to login
          }
        });
        return;
      }
    }

    setState(() { message = "Email not found."; isError = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 20,
            child: Container(
              alignment: Alignment.center,
              child: const Text("Forgot your password?", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          Expanded(
            flex: 80,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter Email", style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: _emailController,
                      onChanged: _clearError, // FIXED: Clears error when typing
                    ),
                    const SizedBox(height: 20),
                    
                    const Text("New Password", style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: _newPasswordController, 
                      obscureText: _isObscureNew,
                      onChanged: _clearError, // FIXED: Clears error when typing
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_isObscureNew ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _isObscureNew = !_isObscureNew),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text("Confirm New Password", style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: _confirmPasswordController, 
                      obscureText: _isObscureConfirm,
                      onChanged: _clearError, // FIXED: Clears error when typing
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (message.isNotEmpty)
                      Text(message, style: TextStyle(color: isError ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(400, 60),
                        backgroundColor: Colors.orange,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: _handleUpdatePassword,
                      child: const Text("Update Password", style: TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                    const SizedBox(height: 30),
                    
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("Back to Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.orange)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}