import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/login_providers.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';
import 'signup_Page.dart';
import 'home.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  //TODO:: LOGIN FUNCTION

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final notifier = ref.read(loginProvider.notifier);

    // Validate username
    notifier.validateUsername(
      _usernameController.text,
    );

    // Validate password
    notifier.validatePassword(
      _passwordController.text,
    );

    // Get latest validation state
    final loginState = ref.read(loginProvider);

    // Stop login if there is any validation error
    if (loginState.usernameError != null ||
        loginState.passwordError != null) {
      return;
    }

    try {
      final result = await notifier.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.welcomeUser} '
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
    }
  }

  //TODO:: MAIN SCREEN

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Top-right decorative circle
          _buildTopRightCircle(),

          // Bottom-left decorative circle
          _buildBottomLeftCircle(),

          // Login form
          _buildLoginForm(context),

          // Screen-level loading overlay
          if (loginState.isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  //TODO:: TOP-RIGHT DECORATIVE CIRCLE

  Widget _buildTopRightCircle() {
    return Positioned(
      top: -100,
      right: 0,
      child: _decorativeCircle(),
    );
  }

  //TODO::BOTTOM-LEFT DECORATIVE CIRCLE

  Widget _buildBottomLeftCircle() {
    return Positioned(
      bottom: -150,
      left: -50,
      child: _decorativeCircle(),
    );
  }

  //TODO:: LOGIN FORM

  Widget _buildLoginForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: Center(
            child: SizedBox(
              width: 327,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Login title and subtitle
                      _buildLoginHeader(),

                      const SizedBox(height: 30),

                      // Username section
                      _buildUsernameField(),

                      const SizedBox(height: 18),

                      // Password section
                      _buildPasswordField(),

                      const SizedBox(height: 25),

                      // Login button
                      _buildLoginButton(),

                      const SizedBox(height: 25),

                      // Signup section
                      _buildSignupSection(),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //TODO:: LOGIN HEADER

  Widget _buildLoginHeader() {
    return Column(
      children: [
        // TITLE
        Text(
          AppStrings.loginTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 10),

        // SUBTITLE
        Text(
          AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 16,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  //TODO:: USERNAME FIELD

  Widget _buildUsernameField() {
    final usernameError =
        ref.watch(loginProvider).usernameError;

    return Column(
      children: [
        // USERNAME LABEL
        SizedBox(
          width: 327,
          child: Text(
            AppStrings.usernameLabel,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // USERNAME INPUT
        TextFormField(
          controller: _usernameController,

          onTap: () {
            if (usernameError != null) {
              ref
                  .read(loginProvider.notifier)
                  .validateUsername(
                _usernameController.text,
              );
            }
          },

          onChanged: (value) {
            if (value.trim().isNotEmpty &&
                usernameError != null) {
              ref
                  .read(loginProvider.notifier)
                  .validateUsername(value);
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

            errorText: usernameError,

            errorBorder: _border(),
            focusedErrorBorder: _focusedBorder(),

            errorStyle: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 12,
              color: AppColors.red,
            ),
          ),

          validator: (_) {
            return null;
          },
        ),
      ],
    );
  }

  //TODO::PASSWORD FIELD

  Widget _buildPasswordField() {
    final passwordError =
        ref.watch(loginProvider).passwordError;

    return Column(
      children: [
        // PASSWORD LABEL
        SizedBox(
          width: 327,
          child: Text(
            AppStrings.passwordLabel,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // PASSWORD INPUT
        TextFormField(
          controller: _passwordController,

          obscureText: true,

          onTap: () {
            if (passwordError ==
                AppStrings.passwordRequired) {
              ref
                  .read(loginProvider.notifier)
                  .validatePassword(
                _passwordController.text,
              );
            }
          },

          onChanged: (value) {
            ref
                .read(loginProvider.notifier)
                .validatePassword(value);
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

            errorText: passwordError,

            errorBorder: _border(),
            focusedErrorBorder: _focusedBorder(),

            errorStyle: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 12,
              color: AppColors.red,
            ),
          ),

          validator: (_) {
            return null;
          },
        ),
      ],
    );
  }

  //TODO:: LOGIN BUTTON

  Widget _buildLoginButton() {
    final isLoading =
        ref.watch(loginProvider).isLoading;

    return SizedBox(
      width: 327,
      height: 61,
      child: ElevatedButton(
        onPressed: isLoading ? null : _login,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,

          disabledBackgroundColor:
          AppColors.primaryOrange,

          foregroundColor: AppColors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        child: Text(
          AppStrings.loginButton,
          style: const TextStyle(
            fontFamily: AppStrings.dmSansFont,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  //TODO:: SIGNUP SECTION

  Widget _buildSignupSection() {
    return SizedBox(
      width: 327,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.noAccount,
            style: const TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 14,
              color: AppColors.darkGrey,
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const SignupPage(),
                ),
              );
            },

            child: Text(
              AppStrings.signUp,
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

  //TODO::LOADING OVERLAY

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

  //TODO:: DECORATIVE CIRCLE

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

  //TODO:: INPUT BORDER

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.searchBorder,
      ),
    );
  }

  //TODO:: FOCUSED INPUT BORDER

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.primaryOrange,
      ),
    );
  }

  //TODO::DISPOSE CONTROLLERS

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}