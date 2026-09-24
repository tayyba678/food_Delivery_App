import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/signup_provider.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';
import 'home.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _firstNameController =
  TextEditingController();

  final TextEditingController _lastNameController =
  TextEditingController();

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  // TODO: SIGNUP FUNCTION

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    final notifier = ref.read(signupProvider.notifier);

    // Validate all fields
    notifier.validateFirstName(
      _firstNameController.text,
    );

    notifier.validateLastName(
      _lastNameController.text,
    );

    notifier.validateUsername(
      _usernameController.text,
    );

    notifier.validatePassword(
      _passwordController.text,
    );

    // Get latest validation state
    final signupState = ref.read(signupProvider);

    // Stop signup if there is any error
    if (signupState.hasError) {
      return;
    }

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
    }
  }

  // TODO: MAIN SCREEN

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);

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
          if (signupState.isLoading) _buildLoadingOverlay(),
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
    final firstNameError =
        ref.watch(signupProvider).firstNameError;

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
              if (firstNameError != null) {
                ref
                    .read(signupProvider.notifier)
                    .clearFirstNameError();
              }
            },

            onChanged: (value) {
              if (value.trim().isNotEmpty &&
                  firstNameError != null) {
                ref
                    .read(signupProvider.notifier)
                    .clearFirstNameError();
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

  // TODO: LAST NAME FIELD

  Widget _buildLastNameField() {
    final lastNameError =
        ref.watch(signupProvider).lastNameError;

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
              if (lastNameError != null) {
                ref
                    .read(signupProvider.notifier)
                    .clearLastNameError();
              }
            },

            onChanged: (value) {
              if (value.trim().isNotEmpty &&
                  lastNameError != null) {
                ref
                    .read(signupProvider.notifier)
                    .clearLastNameError();
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

  // TODO: USERNAME FIELD

  Widget _buildUsernameField() {
    final usernameError =
        ref.watch(signupProvider).usernameError;

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
              if (usernameError != null) {
                ref
                    .read(signupProvider.notifier)
                    .clearUsernameError();
              }
            },

            onChanged: (value) {
              if (value.trim().isNotEmpty &&
                  usernameError != null) {
                ref
                    .read(signupProvider.notifier)
                    .clearUsernameError();
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

  // TODO: PASSWORD FIELD

  Widget _buildPasswordField() {
    final passwordError =
        ref.watch(signupProvider).passwordError;

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
              ref
                  .read(signupProvider.notifier)
                  .clearPasswordRequiredError();
            },

            onChanged: (value) {
              ref
                  .read(signupProvider.notifier)
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
          ),
        ),
      ],
    );
  }

  // TODO: SIGNUP BUTTON

  Widget _buildSignupButton() {
    final isLoading =
        ref.watch(signupProvider).isLoading;

    return SizedBox(
      width: 327,
      height: 61,
      child: ElevatedButton(
        onPressed: isLoading ? null : _signup,

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