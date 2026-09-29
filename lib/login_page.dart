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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // TODO:: LOGIN FUNCTION
  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final notifier = ref.read(loginProvider.notifier);

    notifier.validateUsername(_usernameController.text);
    notifier.validatePassword(_passwordController.text);

    final loginState = ref.read(loginProvider);
    if (loginState.usernameError != null || loginState.passwordError != null) {
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
            '${AppStrings.welcomeUser} ${result['firstName'] ?? AppStrings.defaultUser}',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildTopRightCircle(),
          _buildBottomLeftCircle(),
          _buildLoginForm(context),
          if (loginState.isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopRightCircle() {
    return Positioned(top: -100, right: 0, child: _decorativeCircle());
  }

  Widget _buildBottomLeftCircle() {
    return Positioned(bottom: -150, left: -50, child: _decorativeCircle());
  }

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
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLoginHeader(),
                      const SizedBox(height: 30),
                      _buildUsernameField(),
                      const SizedBox(height: 18),
                      _buildPasswordField(),
                      const SizedBox(height: 25),
                      _buildLoginButton(),
                      const SizedBox(height: 25),
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

  Widget _buildLoginHeader() {
    return Column(
      children: [
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

  Widget _buildUsernameField() {
    final usernameError = ref.watch(loginProvider).usernameError;
    return Column(
      children: [
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
        TextFormField(
          controller: _usernameController,
          onTap: () {
            if (usernameError != null) {
              ref.read(loginProvider.notifier).validateUsername(_usernameController.text);
            }
          },
          onChanged: (value) {
            if (value.trim().isNotEmpty && usernameError != null) {
              ref.read(loginProvider.notifier).validateUsername(value);
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
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    final passwordError = ref.watch(loginProvider).passwordError;
    return Column(
      children: [
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
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          onTap: () {
            if (passwordError == AppStrings.passwordRequired) {
              ref.read(loginProvider.notifier).validatePassword(_passwordController.text);
            }
          },
          onChanged: (value) => ref.read(loginProvider.notifier).validatePassword(value),
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
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    final isLoading = ref.watch(loginProvider).isLoading;
    return SizedBox(
      width: 327,
      height: 61,
      child: ElevatedButton(
        onPressed: isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          disabledBackgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildSignupSection() {
    return SizedBox(
      width: 327,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.noAccount,
            style: TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 14,
              color: AppColors.darkGrey,
            ),
          ),
          TextButton(
            onPressed: () {
              // Changed push to pushReplacement to clear state
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              );
            },
            child: const Text(
              AppStrings.signUp,
              style: TextStyle(
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

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ),
    );
  }

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

  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.searchBorder),
      );

  OutlineInputBorder _focusedBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryOrange),
      );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
