import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:media_radar/services/AuthService.dart';
import '../../constants/Constant.dart';

class Registerprofile extends StatefulWidget {
  final String email;
  const Registerprofile({required this.email, super.key});

  @override
  State<Registerprofile> createState() => _RegisterprofileState();
}

class _RegisterprofileState extends State<Registerprofile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _userNameContrl = TextEditingController();
  final TextEditingController _passContrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String erorText = '';
  bool _obscureText = true;
  bool _isLoading = false;

  String? _commonValidator(String? value, String label) {
    if (value == null || value.isEmpty) {
      return '$label hissəsini doldurun';
    }
    if (value.length < 4) {
      return '$label ən azı 4 simvol olmalıdır';
    }
    return null;
  }

  // Uğur Dialogunu göstərən funksiya
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // 5 saniyə sonra Login səhifəsinə yönləndirmə
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
                  'Qeydiyyatdan uğurla keçdiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 25),
                const Text(
                  '5 saniyə sonra Login səhifəsinə yönləndiriləcəksiniz...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        erorText = ''; // Hər dəfə yeni sorğuda xətanı təmizləyirik
      });

      try {
        var response = await AuthService.registerProfile(
          _userNameContrl.text,
          _nameController.text,
          widget.email,
          _surnameController.text,
          _passContrl.text,
        );

        if (response == "") {
          if (mounted) {
            _showSuccessDialog();
          }
        } else {
          setState(() {
            try {
              var decoded = jsonDecode(response);
              erorText = decoded['error'] ?? decoded['msg'] ?? decoded['detail'] ?? response;
            } catch (_) {
              erorText = response;
            }
          });
        }
      } catch (e) {
        setState(() {
          erorText = "Bağlantı xətası baş verdi.";
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 132,
                    height: 38,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Group.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Qeydiyyat',
                  style: TextStyle(
                    fontSize: 24,
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
                      const Text('İstifadəçi adı', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _userNameContrl,
                        decoration: _inputDeco("İstifadəçi adı"),
                        validator: (v) => _commonValidator(v, "İstifadəçi adı"),
                      ),
                      const SizedBox(height: 20),

                      const Text('Ad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDeco("Adınız"),
                        validator: (v) => _commonValidator(v, "Ad"),
                      ),
                      const SizedBox(height: 20),

                      const Text('Soyad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _surnameController,
                        decoration: _inputDeco("Soyadınız"),
                        validator: (v) => _commonValidator(v, "Soyad"),
                      ),
                      const SizedBox(height: 20),

                      const Text('Şifrə', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passContrl,
                        obscureText: _obscureText,
                        decoration: _inputDeco("••••••••").copyWith(
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Şifrəni doldurun';
                          // Regex: 8 simvol, 1 böyük, 1 rəqəm, 1 xüsusi simvol
                          RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$');
                          if (!regex.hasMatch(value)) {
                            return 'Azı 8 simvol, 1 böyük hərf, 1 rəqəm və 1 simvol.';
                          }
                          return null;
                        },
                      ),

                      if (erorText.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Text(
                          erorText,
                          style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      ],

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.baseColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : register,
                          child: _isLoading
                              ? const SizedBox(
                              width: 24, height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Qeydiyyatı keç',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text('Geriyə',
                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
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

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}