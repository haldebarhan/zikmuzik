import 'package:flutter/material.dart';
import 'package:zikmuzik/core/services/biometric_service.dart';
import 'package:zikmuzik/core/storages/secure_storage.dart';
import 'package:zikmuzik/features/auth/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final Color _primaryColor = const Color(0xFF4F46E5);
  final Color _darkTextColor = const Color(0xFF0F172A);
  final Color _bodyTextColor = const Color(0XFF475569);
  final Color _borderColor = const Color(0XFFE2E8F0);
  final Color _bgLightColor = const Color(0xFFF8FAFC);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthRepository().loginWithEmail(email, password);

      if (response.statusCode == 200) {
        await SecureStorage.saveAccessToken(response.data['accessToken']);
        final biometricService = BiometricAuthService();
        final canUseBiometric = await biometricService.isBiometricAvailable();
        if (canUseBiometric) {
          Get.toNamed('/biometric');
        } else {
          Get.toNamed('/home');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email ou mot de passe incorrect")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLightColor,
      body: Stack(
        children: [
          _BackgroundDecoration(color: _primaryColor),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        _LoginHeader(
                          darkColor: _darkTextColor,
                          bodyColor: _bodyTextColor,
                        ),
                        const SizedBox(height: 40),
                        _LoginFormField(
                          primaryColor: _primaryColor,
                          darkColor: _darkTextColor,
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          isPasswordVisible: _isPasswordVisible,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onTogglePasswordVisibility: () {
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _LoginButton(
                          btnColor: _darkTextColor,
                          isLoading: _isLoading,
                          onPressed: _login,
                        ),
                        const SizedBox(height: 20),
                        _SocialLoginSection(
                          bodyColor: _bodyTextColor,
                          darkColor: _darkTextColor,
                          borderColor: _borderColor,
                        ),
                        const SizedBox(height: 20),
                        _FooterSection(
                          primaryColor: _primaryColor,
                          bodyColor: _bodyTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  final Color color;
  const _BackgroundDecoration({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: _blob(280, color.withValues(alpha: .08)),
        ),
        Positioned(
          bottom: -80,
          right: -60,
          child: _blob(230, color.withValues(alpha: .12)),
        ),
      ],
    );
  }

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _LoginHeader extends StatelessWidget {
  final Color darkColor, bodyColor;

  const _LoginHeader({required this.darkColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        Text(
          "Connectez-vous",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: darkColor,
            letterSpacing: -2,
          ),
        ),
        Text(
          "Entrez vous identifiants pour continuer",
          style: TextStyle(fontSize: 16, color: bodyColor, height: 1.5),
        ),
      ],
    );
  }
}

class _LoginFormField extends StatelessWidget {
  final Color primaryColor, darkColor, bodyColor, borderColor;
  final bool isPasswordVisible;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onTogglePasswordVisibility;

  const _LoginFormField({
    required this.primaryColor,
    required this.darkColor,
    required this.bodyColor,
    required this.borderColor,
    required this.isPasswordVisible,
    required this.emailController,
    required this.passwordController,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Email"),
        inputField(
          Icons.email_outlined,
          "Entrez votre email",
          controller: emailController,
        ),
        const SizedBox(height: 15),

        label("Mot de passe"),
        inputField(
          Icons.lock_outlined,
          "Entrez votre mot de passe",
          controller: passwordController,
          isPassword: true,
          suffix: IconButton(
            onPressed: onTogglePasswordVisibility,
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              size: 20,
              color: bodyColor.withValues(alpha: .6),
            ),
          ),
        ),
      ],
    );
  }

  // label et inputField restent presque identiques...
  Widget label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: bodyColor.withValues(alpha: .8),
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget inputField(
    IconData icon,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
    Widget? suffix,
  }) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: darkColor.withValues(alpha: .03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: TextStyle(color: darkColor, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: bodyColor.withValues(alpha: .4),
          fontSize: 15,
        ),
        prefixIcon: Icon(icon, color: primaryColor, size: 22),
        suffixIcon: suffix,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
    ),
  );
}

class _LoginButton extends StatelessWidget {
  final Color btnColor;
  final bool isLoading;
  final VoidCallback onPressed;
  const _LoginButton({
    required this.btnColor,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: const Text(
          "Se connecter",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _SocialLoginSection extends StatelessWidget {
  final Color bodyColor, darkColor, borderColor;
  const _SocialLoginSection({
    required this.bodyColor,
    required this.darkColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Ou continuer avec",
            style: TextStyle(
              color: bodyColor.withValues(alpha: .7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _tile(
              "Google",
              "https://img.icons8.com/color/48/000000/google-logo.png",
            ),
            const SizedBox(width: 16),
            _tile("Apple", null, icon: Icons.apple),
          ],
        ),
      ],
    );
  }

  Widget _tile(String label, String? imageUrl, {IconData? icon}) => Expanded(
    child: Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusGeometry.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageUrl != null)
            Image.network(imageUrl, height: 24)
          else
            Icon(icon, size: 22, color: darkColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: darkColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}

class _FooterSection extends StatelessWidget {
  final Color primaryColor, bodyColor;
  const _FooterSection({required this.primaryColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous n'avez pas de compte ?", style: TextStyle(color: bodyColor)),
        TextButton(
          onPressed: () {},
          child: Text(
            "S'inscrire",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
