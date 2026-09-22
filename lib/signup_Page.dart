import 'package:flutter/material.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';
import 'api/auth_api.dart';
import 'home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController =
  TextEditingController();

  final TextEditingController _lastNameController =
  TextEditingController();

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _isLoading = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _usernameError;
  String? _passwordError;

  // TODO: SIGNUP FUNCTION

  Future<void> _signup() async {
    // Validate first name
    if (_firstNameController.text.trim().isEmpty) {
      _firstNameError = 'First name is required';
    } else {
      _firstNameError = null;
    }

    // Validate last name
    if (_lastNameController.text.trim().isEmpty) {
      _lastNameError = 'Last name is required';
    } else {
      _lastNameError = null;
    }

    // Validate username
    if (_usernameController.text.trim().isEmpty) {
      _usernameError = AppStrings.userNameRequired;
    } else {
      _usernameError = null;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      _passwordError = AppStrings.passwordRequired;
    } else if (_passwordController.text.length < 6) {
      _passwordError = AppStrings.passwordMinLength;
    } else {
      _passwordError = null;
    }

    // Refresh UI after validation
    setState(() {});

    // Stop signup if there is any error
    if (_firstNameError != null ||
        _lastNameError != null ||
        _usernameError != null ||
        _passwordError != null) {
      return;
    }

    // Start screen loader
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthApi.signup(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.signupSuccess} '
                '${result['firstName'] ?? AppStrings.defaultUser}',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // TODO: MAIN SCREEN

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Top-right decorative circle
          _buildTopRightCircle(),

          // Bottom-left decorative circle
          _buildBottomLeftCircle(),

          // Signup form
          _buildSignupForm(),

          // Screen-level loading overlay
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // TODO: TOP-RIGHT DECORATIVE CIRCLE

  Widget _buildTopRightCircle() {
    return Positioned(
      top: -100,
      right: 0,
      child: _decorativeCircle(),
    );
  }

  // TODO: BOTTOM-LEFT DECORATIVE CIRCLE

  Widget _buildBottomLeftCircle() {
    return Positioned(
      bottom: -150,
      left: -50,
      child: _decorativeCircle(),
    );
  }

  // TODO: SIGNUP FORM

  Widget _buildSignupForm() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 327,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Signup title and subtitle
                  _buildSignupHeader(),

                  // First name field
                  _buildFirstNameField(),

                  const SizedBox(height: 18),

                  // Last name field
                  _buildLastNameField(),

                  const SizedBox(height: 18),

                  // Username field
                  _buildUsernameField(),

                  const SizedBox(height: 18),

                  // Password field
                  _buildPasswordField(),

                  const SizedBox(height: 25),

                  // Signup button
                  _buildSignupButton(),

                  const SizedBox(height: 25),

                  // Login section
                  _buildLoginSection(),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TODO: SIGNUP HEADER

  Widget _buildSignupHeader() {
    return Column(
      children: [
        Center(
          child: Text(
            AppStrings.signupTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: Text(
            AppStrings.signupSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 16,
              color: AppColors.darkGrey,
            ),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  // TODO: FIRST NAME FIELD

  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.firstNameLabel,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 327,
          child: TextField(
            controller: _firstNameController,

            onTap: () {
              if (_firstNameError != null) {
                setState(() {
                  _firstNameError = null;
                });
              }
            },

            onChanged: (value) {
              if (value.trim().isNotEmpty &&
                  _firstNameError != null) {
                setState(() {
                  _firstNameError = null;
                });
              }
            },

            decoration: InputDecoration(
              hintText: AppStrings.firstNameHint,

              hintStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                color: AppColors.searchHint,
              ),

              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _focusedBorder(),

              errorText: _firstNameError,

              errorBorder: _border(),
              focusedErrorBorder: _focusedBorder(),

              errorStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                fontSize: 12,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO: LAST NAME FIELD

  Widget _buildLastNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.lastNameLabel,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 327,
          child: TextField(
            controller: _lastNameController,

            onTap: () {
              if (_lastNameError != null) {
                setState(() {
                  _lastNameError = null;
                });
              }
            },

            onChanged: (value) {
              if (value.trim().isNotEmpty &&
                  _lastNameError != null) {
                setState(() {
                  _lastNameError = null;
                });
              }
            },

            decoration: InputDecoration(
              hintText: AppStrings.lastNameHint,

              hintStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                color: AppColors.searchHint,
              ),

              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _focusedBorder(),

              errorText: _lastNameError,

              errorBorder: _border(),
              focusedErrorBorder: _focusedBorder(),

              errorStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                fontSize: 12,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO: USERNAME FIELD

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.usernameLabel,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 327,
          child: TextField(
            controller: _usernameController,

            onTap: () {
              if (_usernameError != null) {
                setState(() {
                  _usernameError = null;
                });
              }
            },

            onChanged: (value) {
              if (value.trim().isNotEmpty &&
                  _usernameError != null) {
                setState(() {
                  _usernameError = null;
                });
              }
            },

            decoration: InputDecoration(
              hintText: AppStrings.usernameHint,

              hintStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                color: AppColors.searchHint,
              ),

              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _focusedBorder(),

              errorText: _usernameError,

              errorBorder: _border(),
              focusedErrorBorder: _focusedBorder(),

              errorStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                fontSize: 12,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO: PASSWORD FIELD

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.passwordLabel,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 327,
          child: TextField(
            controller: _passwordController,

            obscureText: true,

            // Remove "Password is required"
            // when user clicks the field.
            onTap: () {
              if (_passwordError ==
                  AppStrings.passwordRequired) {
                setState(() {
                  _passwordError = null;
                });
              }
            },

            onChanged: (value) {
              setState(() {
                if (value.length >= 6) {
                  _passwordError = null;
                } else if (value.isNotEmpty) {
                  _passwordError =
                      AppStrings.passwordMinLength;
                } else {
                  _passwordError = null;
                }
              });
            },

            decoration: InputDecoration(
              hintText: AppStrings.passwordHint,

              hintStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                color: AppColors.searchHint,
              ),

              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _focusedBorder(),

              errorText: _passwordError,

              errorBorder: _border(),
              focusedErrorBorder: _focusedBorder(),

              errorStyle: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                fontSize: 12,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO: SIGNUP BUTTON

  Widget _buildSignupButton() {
    return SizedBox(
      width: 327,
      height: 61,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signup,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,

          foregroundColor: AppColors.white,

          disabledBackgroundColor:
          AppColors.primaryOrange,

          disabledForegroundColor:
          AppColors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // No loader inside button
        child: Text(
          AppStrings.signupButton,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // TODO: LOGIN SECTION

  Widget _buildLoginSection() {
    return SizedBox(
      width: 327,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.alreadyAccount,
            style: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 14,
              color: AppColors.darkGrey,
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: Text(
              AppStrings.loginButton,
              style: const TextStyle(
                fontFamily: AppStrings.dmSansFont,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: LOADING OVERLAY

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryOrange,
        ),
      ),
    );
  }

  // TODO: DECORATIVE CIRCLE

  Widget _decorativeCircle() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryOrange,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }

  // TODO: INPUT BORDER

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.searchBorder,
      ),
    );
  }

  // TODO: FOCUSED INPUT BORDER

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.primaryOrange,
      ),
    );
  }

  // TODO: DISPOSE CONTROLLERS

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}