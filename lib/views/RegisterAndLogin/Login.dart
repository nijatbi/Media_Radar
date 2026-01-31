import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import 'package:media_radar/views/HomePages/HomePage.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorText = '';
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false; // Giriş zamanı düymənin vəziyyəti üçün

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Klaviatura açılan zaman overflow-un qarşısını alır
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Container(
                  width: 132,
                  height: 38,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Group.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Constant.loginText1,
                const SizedBox(height: 10),
                Constant.loginText2,
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (errorText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            errorText,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      const Text(
                        'İstifadəçi adı',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "İstifadəçi adı",
                          hintStyle: TextStyle(color: Constant.inputHintTextColor),
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constant.inputBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constant.baseColor, width: 1.5),
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'İstifadəçi adını doldur'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Şifrə',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Şifrə",
                          hintStyle: TextStyle(color: Constant.inputHintTextColor),
                          contentPadding: const EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constant.inputBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constant.baseColor, width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Şifrəni doldur'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                  activeColor: Constant.baseColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text("Məni xatırla", style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          Constant.forgotPaswordText,
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.baseColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : loginProcess,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginProcess() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await AuthService.login(
          usernameController.text,
          passwordController.text,
        );

        final Map<String, dynamic> data = jsonDecode(response);

        if (data.containsKey('access_token')) {
          await SecureStorageService.saveToken(data["access_token"]);

          if (!mounted) return;
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.getCurrentUser();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
          );
        } else {
          setState(() {
            errorText = data['detail'] ?? data['error'] ?? 'Giriş uğursuz oldu';
          });
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => errorText = '');
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sistem xətası: $e')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}