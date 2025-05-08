import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // Import the Home page

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  bool _isButtonPressed = false;
  bool _isLoading = false;

  // Create FocusNodes for each input field
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _saveInfoToDb() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);

      // Save to shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _name ?? '');
      await prefs.setString('email', _email ?? '');
      await prefs.setString('password', _password ?? '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Account created successfully!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.teal[600],
        ),
      );

      setState(() => _isLoading = false);
      // Navigate to Home page after signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the focus nodes to avoid memory leaks
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[900]!, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.grey[850],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Join LifeHub",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          focusNode: _nameFocusNode, // Attach the FocusNode
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            hintText: "John Doe",
                            labelStyle: TextStyle(
                                color: Colors.grey[400], fontFamily: 'Poppins'),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[700]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.teal[400]!, width: 2),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                          onSaved: (value) => _name = value,
                          onTap: () {
                            _nameFocusNode
                                .requestFocus(); // Request focus to show keyboard
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          focusNode: _emailFocusNode, // Attach the FocusNode
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            hintText: "example@example.com",
                            labelStyle: TextStyle(
                                color: Colors.grey[400], fontFamily: 'Poppins'),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[700]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.teal[400]!, width: 2),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            final emailRegex = RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                            if (!emailRegex.hasMatch(value)) {
                              return "Invalid email format";
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value,
                          onTap: () {
                            _emailFocusNode
                                .requestFocus(); // Request focus to show keyboard
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          focusNode: _passwordFocusNode, // Attach the FocusNode
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter a strong password",
                            labelStyle: TextStyle(
                                color: Colors.grey[400], fontFamily: 'Poppins'),
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[700]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.teal[400]!, width: 2),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 8) {
                              return "Password must be at least 8 characters long";
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value,
                          onTap: () {
                            _passwordFocusNode
                                .requestFocus(); // Request focus to show keyboard
                          },
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTapDown: (_) =>
                              setState(() => _isButtonPressed = true),
                          onTapUp: (_) {
                            setState(() => _isButtonPressed = false);
                            _saveInfoToDb();
                          },
                          onTapCancel: () =>
                              setState(() => _isButtonPressed = false),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            transform: Matrix4.identity()
                              ..scale(_isButtonPressed ? 0.95 : 1.0),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.teal[400]!, Colors.teal[600]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
