import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../constants/Constant.dart';
import '../../services/AuthService.dart';

class ForgotPass extends StatefulWidget {
  final String email;
  const ForgotPass({required this.email, super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController _passContrl = TextEditingController();
  final TextEditingController _repeatPassContrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorText = '';
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  bool _isLoading = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifrəni daxil edin';
    }
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})');
    if (!passwordRegex.hasMatch(value)) {
      return 'Şifrə: min. 8 simvol, 1 böyük hərf, 1 rəqəm və 1 simvol (!@#\$) olmalıdır';
    }
    return null;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Timer(const Duration(seconds: 5), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'Təbriklər!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Şifrə uğurla dəyişdirildi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 25),
                const Text(
                  '5 saniyə sonra giriş səhifəsinə yönləndiriləcəksiniz...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                const CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }

  void changePass() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passContrl.text != _repeatPassContrl.text) {
      setState(() => errorText = 'Şifrələr eyni deyil!');
      return;
    }

    setState(() {
      _isLoading = true;
      errorText = '';
    });

    try {
      var response = await AuthService.changePass(
        widget.email,
        _passContrl.text,
        _repeatPassContrl.text,
      );

      if (response == "") {
        if (mounted) _showSuccessDialog();
      } else {
        setState(() {
          try {
            var decoded = jsonDecode(response);
            errorText = decoded['error'] ?? "Xəta baş verdi";
          } catch (e) {
            errorText = "Sistem xətası: $response";
          }
        });
      }
    } catch (e) {
      setState(() => errorText = "Bağlantı xətası baş verdi.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/Group.png',
                  width: 132,
                  height: 38,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Yeni şifrə daxil edin',
                style: TextStyle(
                  fontSize: 20,
                  color: Constant.baseColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordField(
                      label: "Yeni Şifrə",
                      controller: _passContrl,
                      validator: _validatePassword,
                      obsureText: _obscureText1
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: "Şifrəni təkrarla",
                      controller: _repeatPassContrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Şifrə təkrarını daxil edin';
                        if (value != _passContrl.text) return 'Şifrələr uyğun gəlmir';
                        return null;
                      },
                        obsureText: _obscureText2

                    ),

                    if (errorText.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(
                        errorText,
                        style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    ],

                    const SizedBox(height: 40),

                    _buildButton(
                      text: 'Təsdiqlə',
                      color: Constant.baseColor,
                      textColor: Colors.white,
                      onPressed: _isLoading ? null : changePass,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 15),

                    _buildButton(
                      text: 'Geriyə',
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                              (route) => false,
                        );
                      },
                      isOutlined: true,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required bool obsureText,
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: obsureText,
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Constant.inputHintTextColor, fontSize: 14),
            contentPadding: const EdgeInsets.all(16),
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Constant.inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Constant.baseColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => obsureText = !obsureText),
              icon: Icon(obsureText ? Icons.visibility : Icons.visibility_off, size: 20),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: isOutlined ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(text, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void dispose() {
    _passContrl.dispose();
    _repeatPassContrl.dispose();
    super.dispose();
  }
}