import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/signup_provider.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';
import 'home.dart';
import 'login_page.dart'; // Added import for LoginPage

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // TODO: SIGNUP FUNCTION
  Future<void> _signup() async {
    FocusScope.of(context).unfocus();
    final notifier = ref.read(signupProvider.notifier);

    notifier.validateFirstName(_firstNameController.text);
    notifier.validateLastName(_lastNameController.text);
    notifier.validateUsername(_usernameController.text);
    notifier.validatePassword(_passwordController.text);

    final signupState = ref.read(signupProvider);
    if (signupState.hasError) return;

    try {
      final result = await notifier.signup(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.signupSuccess} ${result['firstName'] ?? AppStrings.defaultUser}',
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
    final signupState = ref.watch(signupProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildTopRightCircle(),
          _buildBottomLeftCircle(),
          _buildSignupForm(),
          if (signupState.isLoading) _buildLoadingOverlay(),
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

  Widget _buildSignupForm() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 327,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSignupHeader(),
                  _buildFirstNameField(),
                  const SizedBox(height: 18),
                  _buildLastNameField(),
                  const SizedBox(height: 18),
                  _buildUsernameField(),
                  const SizedBox(height: 18),
                  _buildPasswordField(),
                  const SizedBox(height: 25),
                  _buildSignupButton(),
                  const SizedBox(height: 25),
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

  Widget _buildFirstNameField() {
    final firstNameError = ref.watch(signupProvider).firstNameError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.firstNameLabel,
          style: TextStyle(
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
              if (firstNameError != null) {
                ref.read(signupProvider.notifier).clearFirstNameError();
              }
            },
            onChanged: (value) {
              if (value.trim().isNotEmpty && firstNameError != null) {
                ref.read(signupProvider.notifier).clearFirstNameError();
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
              errorText: firstNameError,
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

  Widget _buildLastNameField() {
    final lastNameError = ref.watch(signupProvider).lastNameError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.lastNameLabel,
          style: TextStyle(
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
              if (lastNameError != null) {
                ref.read(signupProvider.notifier).clearLastNameError();
              }
            },
            onChanged: (value) {
              if (value.trim().isNotEmpty && lastNameError != null) {
                ref.read(signupProvider.notifier).clearLastNameError();
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
              errorText: lastNameError,
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

  Widget _buildUsernameField() {
    final usernameError = ref.watch(signupProvider).usernameError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.usernameLabel,
          style: TextStyle(
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
              if (usernameError != null) {
                ref.read(signupProvider.notifier).clearUsernameError();
              }
            },
            onChanged: (value) {
              if (value.trim().isNotEmpty && usernameError != null) {
                ref.read(signupProvider.notifier).clearUsernameError();
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
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    final passwordError = ref.watch(signupProvider).passwordError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.passwordLabel,
          style: TextStyle(
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
            onTap: () {
              ref.read(signupProvider.notifier).clearPasswordRequiredError();
            },
            onChanged: (value) {
              ref.read(signupProvider.notifier).validatePassword(value);
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
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    final isLoading = ref.watch(signupProvider).isLoading;
    return SizedBox(
      width: 327,
      height: 61,
      child: ElevatedButton(
        onPressed: isLoading ? null : _signup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primaryOrange,
          disabledForegroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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

  Widget _buildLoginSection() {
    return SizedBox(
      width: 327,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.alreadyAccount,
            style: TextStyle(
              fontFamily: AppStrings.dmSansFont,
              fontSize: 14,
              color: AppColors.darkGrey,
            ),
          ),
          TextButton(
            onPressed: () {
              // Changed pop to pushReplacement to clear state
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              AppStrings.loginButton,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
