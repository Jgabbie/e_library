import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String usernameError = "";
  String passwordError = "";
  
  bool _isObscureCurrent = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  // Your preset Valorant cat images
  final List<String> presetAvatars = [
    'assets/images/catphoenix.jpg',
    'assets/images/catraze.jpg',
    'assets/images/catsova.jpg',
    'assets/images/catsage.jpg',
    'assets/images/catviper.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _usernameController.text = MockDatabase.activeUser?["username"] ?? "";
    _emailController.text = MockDatabase.activeUser?["email"] ?? "";
  }

  void _showAvatarSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Profile Picture", textAlign: TextAlign.center),
        content: SizedBox(
          width: double.maxFinite,
          height: 250,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: presetAvatars.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    MockDatabase.activeUser!["profileImage"] = presetAvatars[index];
                  });
                  Navigator.pop(context); 
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(presetAvatars[index]),
                  backgroundColor: Colors.orange.shade100,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                MockDatabase.activeUser!.remove("profileImage");
              });
              Navigator.pop(context);
            },
            child: const Text("Remove Picture", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _updateUsername() {
    String newUsername = _usernameController.text.trim();
    
    if (newUsername == MockDatabase.activeUser!["username"]) {
      setState(() => usernameError = "You can't change your username to your existing username.");
      return;
    }
    if (newUsername.length < 8 || newUsername.length > 13) {
      setState(() => usernameError = "Username must be between 8 and 13 characters.");
      return;
    }
    
    bool isTaken = MockDatabase.users.any((u) => u["username"] == newUsername);
    if (isTaken) {
      setState(() => usernameError = "Username is already taken.");
      return;
    }

    setState(() {
      MockDatabase.activeUser!["username"] = newUsername;
      usernameError = "";
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Username successfully updated!"), backgroundColor: Colors.green),
    );
  }

  void _updatePassword() {
    String current = _currentPasswordController.text;
    String newPass = _newPasswordController.text;
    String confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      setState(() => passwordError = "All password fields are required.");
      return;
    }
    if (current != MockDatabase.activeUser!["password"]) {
      setState(() => passwordError = "Wrong current password.");
      return;
    }
    if (newPass == current) {
      setState(() => passwordError = "New password cannot be the same as current.");
      return;
    }
    if (newPass != confirm) {
      setState(() => passwordError = "New passwords do not match.");
      return;
    }
    if (newPass.length < 8) {
      setState(() => passwordError = "Password must be at least 8 characters long.");
      return;
    }

    bool hasUpper = false;
    bool hasLower = false;
    bool hasDigit = false;
    bool hasSpecial = false;

    String upperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String lowerLetters = "abcdefghijklmnopqrstuvwxyz";
    String numbers = "0123456789";

    for (int i = 0; i < newPass.length; i++) {
      String char = newPass[i];
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
      setState(() => passwordError = "Password needs uppercase, lowercase, number, and special char.");
      return;
    }

    setState(() => passwordError = "");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you want to change password?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () {
              MockDatabase.activeUser!["password"] = newPass;
              MockDatabase.activeUser = null; 
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
        content: const Text("Are you sure you want to delete your account?\n\nWarning: This is permanent."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              MockDatabase.users.removeWhere((u) => u["username"] == MockDatabase.activeUser!["username"]);
              MockDatabase.activeUser = null;
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? profileImagePath = MockDatabase.activeUser?["profileImage"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showAvatarSelector, 
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: profileImagePath != null ? AssetImage(profileImagePath) : null,
                      child: profileImagePath == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
                    ),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 20),

            const Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _usernameController,
              onChanged: (val) => setState(() => usernameError = ""),
            ),
            if (usernameError.isNotEmpty) Text(usernameError, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: _updateUsername,
              child: const Text("Update Username", style: TextStyle(color: Colors.white)),
            ),
            
            const Divider(height: 60, thickness: 2),

            const Text("Change Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            const Text("Current Password"),
            TextField(
              controller: _currentPasswordController,
              obscureText: _isObscureCurrent,
              onChanged: (val) => setState(() => passwordError = ""),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_isObscureCurrent ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscureCurrent = !_isObscureCurrent),
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text("New Password"),
            TextField(
              controller: _newPasswordController,
              obscureText: _isObscureNew,
              onChanged: (val) => setState(() => passwordError = ""),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_isObscureNew ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscureNew = !_isObscureNew),
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text("Retype New Password"),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _isObscureConfirm,
              onChanged: (val) => setState(() => passwordError = ""),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_isObscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                ),
              ),
            ),
            
            if (passwordError.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(passwordError, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: _updatePassword,
              child: const Text("Update Password", style: TextStyle(color: Colors.white)),
            ),

            const Divider(height: 60, thickness: 2),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _deleteAccount,
              child: const Text("Delete Account", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}