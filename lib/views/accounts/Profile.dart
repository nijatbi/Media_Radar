import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/views/RegisterAndLogin/Login.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthProvider.dart';
import '../../services/AuthService.dart';
import '../../services/SecureStorageService.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _obscureOld = true;
  bool _obscureNew = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.getCurrentUser();
    });
  }

  void _openPasswordModal(BuildContext context) {
    TextEditingController _oldPass = TextEditingController();
    TextEditingController _newPass = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String erorText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 80, height: 4,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 30),

                    if (erorText.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                erorText,
                                style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cari Şifrə', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: _obscureOld,
                            controller: _oldPass,
                            decoration: _inputDeco("••••••••", _obscureOld, () {
                              modalSetState(() => _obscureOld = !_obscureOld);
                            }),
                            validator: (v) => v!.isEmpty ? 'Boş qala bilməz' : (v.length < 5 ? 'Minimum 5 simvol' : null),
                          ),
                          const SizedBox(height: 20),
                          const Text('Yeni Şifrə', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _newPass,
                            obscureText: _obscureNew,
                            decoration: _inputDeco("••••••••", _obscureNew, () {
                              modalSetState(() => _obscureNew = !_obscureNew);
                            }),
                            validator: (v) => v!.isEmpty ? 'Boş qala bilməz' : (v.length < 5 ? 'Minimum 5 simvol' : null),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final token = await SecureStorageService.getToken();
                              final response = await http.put(
                                Uri.parse("${AuthService.baseUrl}/user/change_password?old_password=${_oldPass.text}&new_password=${_newPass.text}"),
                                headers: {'Authorization': "Bearer $token", 'Accept': 'application/json'},
                              );

                              if (response.statusCode == 200) {
                                await SecureStorageService.deleteToken();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                      (route) => false,
                                );
                              } else {
                                final Map<String, dynamic> errorData = json.decode(response.body);
                                modalSetState(() {
                                  erorText = errorData['error'] ?? "Xəta baş verdi";
                                });

                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    modalSetState(() => erorText = '');
                                  }
                                });
                              }
                            } catch (e) {
                              modalSetState(() => erorText = "Bağlantı xətası baş verdi");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.baseColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text('Təsdiqlə', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDeco(String hint, bool obscure, VoidCallback toggle) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      hintText: hint,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Constant.inputBorderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Constant.baseColor)),
      suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: toggle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)),
          title: const Text('Hesab', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(),
              const SizedBox(height: 40),
              personInfo(user?.name ?? '', 'Ad'),
              const SizedBox(height: 20),
              personInfo(user?.surname ?? '', 'Soyad'),
              const SizedBox(height: 20),
              personInfo(user?.userName ?? '', 'İstifadəçi adı'),
              const SizedBox(height: 30),
              _buildPasswordField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage('assets/images/profile-42914_640.webp'), fit: BoxFit.cover),
            ),
          ),
          TextButton(onPressed: () {}, child: Text("Şəkli dəyiş", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Constant.forgotPasColor))),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Şifrə', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _openPasswordModal(context),
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Şifrəni dəyiş', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Constant.baseColor)),
                  const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget personInfo(String info, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(info, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}