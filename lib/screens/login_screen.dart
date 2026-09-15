import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscure = true;
  bool _showNameField = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (phone.length < 10) {
      _showSnack('شماره موبایل معتبر نیست');
      return;
    }
    if (password.length < 6) {
      _showSnack('رمز باید حداقل ۶ کاراکتر باشد');
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.loginOrRegister(
      phone: phone,
      password: password,
      fullName: name.isEmpty ? null : name,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      _showSnack(auth.error ?? 'خطا در ورود');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkGoldBorder : AppColors.skyBlue;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // لوگو
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.goldHighlight, AppColors.goldPrimary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldHighlight.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'ورود / ثبت‌نام',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'با شماره موبایل و رمز خود وارد شوید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 36),

                // شماره موبایل
                _buildField(
                  controller: _phoneController,
                  label: 'شماره موبایل',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  isDark: isDark,
                  surface: surface,
                  borderColor: borderColor,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9۰-۹]')),
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),

                const SizedBox(height: 14),

                // رمز عبور
                _buildField(
                  controller: _passwordController,
                  label: 'رمز عبور',
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  isDark: isDark,
                  surface: surface,
                  borderColor: borderColor,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),

                const SizedBox(height: 14),

                // نام (اختیاری)
                if (_showNameField)
                  _buildField(
                    controller: _nameController,
                    label: 'نام و نام خانوادگی (اختیاری)',
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                    surface: surface,
                    borderColor: borderColor,
                  ),

                if (!_showNameField)
                  TextButton(
                    onPressed: () => setState(() => _showNameField = true),
                    child: Text(
                      '+ افزودن نام و نام خانوادگی (اختیاری)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.goldLight
                            : AppColors.goldDark,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // دکمه ورود
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldPrimary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor:
                              AppColors.goldHighlight.withValues(alpha: 0.5),
                        ),
                        child: auth.loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'ورود به اپلیکیشن',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  'با ورود، قوانین و شرایط استفاده را می‌پذیرید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    required Color surface,
    required Color borderColor,
    bool obscure = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: AppColors.goldLight, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
