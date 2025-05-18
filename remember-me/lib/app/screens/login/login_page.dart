import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/api/result.dart';
import 'package:remember_me/app/auth/auth_service.dart';
import 'package:remember_me/app/route/router_service.dart';
// Assuming these imports are still relevant from your original code
// import 'package:remember_me/app/api/api_service.dart';
// import 'package:remember_me/app/auth/auth_service.dart';
// import 'package:go_router/go_router.dart';
// import 'package:remember_me/app/route/router_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// Color constants
const Color pageBackgroundColor = Color(0xFFFFF8E7);
const Color formBackgroundColor = Color(
  0xFFFFEFBF,
); // #FFEFBF from image analysis
const Color buttonAndIconColor = Color(
  0xFFFFCF4E,
); // #FFCF4E from image analysis
const Color titleTextColor = Colors.white;
Color labelTextColor =
    Colors.grey[700]!; // For "Remember me", "Forgot password?"
Color placeholderTextColor = Colors.grey[600]!;
Color linkTextColor = Colors.grey[800]!; // For "Register", "Login" links

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(); // Used for Username/Email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoginMode = true;
  // bool _rememberMe = false; // If "Remember me" was functional

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _isLoading = false; // Reset loading state
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isLoginMode) {
      final result = await ApiService.I.signIn(email, password);
      result.fold(
        onSuccess: (token) async {
          AuthService.I.setTokens(token);
          if (mounted) {
            // context.go(Routes.home); // Original navigation
            GoRouter.of(context).go(Routes.home); // Mock navigation
          }
        },
        onFailure: (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.message)));
          }
        },
      );
    } else {
      final name = _nameController.text.trim();
      final result = await ApiService.I.signUp(email, password, name);
      result.fold(
        onSuccess: (token) async {
          AuthService.I.setTokens(token);
          if (mounted) {
            // context.go(Routes.home); // Original navigation
            GoRouter.of(context).go(Routes.home); // Mock navigation
          }
        },
        onFailure: (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.message)));
          }
        },
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: placeholderTextColor, fontSize: 15),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 12.0),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isLoginMode ? "Login" : "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 35.0),
                  if (!_isLoginMode)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(
                          hintText: 'Name',
                          icon: Icons.badge_outlined,
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter your name'
                                    : null,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: _buildInputDecoration(
                        hintText: 'Username',
                        icon: Icons.person_outline,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter username' : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ), // Reduced bottom padding
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: _buildInputDecoration(
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                      ),
                      obscureText: true,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter password' : null,
                    ),
                  ),

                  if (_isLoginMode)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                        top: 5.0,
                        left: 10.0,
                        right: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                // Representing the checkbox visual from image
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                margin: const EdgeInsets.only(right: 8.0),
                              ),
                              Text(
                                "Remember me",
                                style: TextStyle(
                                  color: labelTextColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Forgot password clicked!'),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(
                                50,
                                20,
                              ), // Smaller tap target
                              tapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap, // Minimize tap area
                              alignment: Alignment.centerRight,
                            ),
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: labelTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!_isLoginMode)
                    const SizedBox(
                      height: 25,
                    ), // Space placeholder for non-login mode

                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.7),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              _isLoginMode ? 'Login' : 'Sign Up',
                              style: const TextStyle(
                                color: titleTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                  const SizedBox(height: 25.0),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: _isLoading ? null : _toggleMode,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: labelTextColor,
                            fontSize: 14.5,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  _isLoginMode
                                      ? "Don't have an account? "
                                      : "Already have an account? ",
                            ),
                            TextSpan(
                              text: _isLoginMode ? "Register" : "Login",
                              style: TextStyle(
                                color: linkTextColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Colors.grey[600], // Underline color
                                decorationThickness: 1.5,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = _isLoading ? null : _toggleMode,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// To run this example standalone:
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: LoginPage(),
//   ));
// }
