import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/Constant.dart';
import '../../services/AuthService.dart';
class ForgotInit extends StatefulWidget {
  const ForgotInit({super.key});

  @override
  State<ForgotInit> createState() => _ForgotInitState();
}

class _ForgotInitState extends State<ForgotInit> {
  final TextEditingController _emailController = TextEditingController();
  String errorText = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    Container(
                      width: 400,
                      height: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/MediaRadar_logo_png.jpg'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Parolu unutmusan?',
                      style: TextStyle(
                        fontSize: 24,
                        color: Constant.baseColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

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
                            'E-mail',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "nümunə@gmail.com",
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Email boş ola bilməz';
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Email formatı yanlışdır';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constant.baseColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                              onPressed: _isLoading ? null : () async {
                                forgotInit();
                              },
                              child: _isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Növbəti', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  elevation: 0,
                                  side: BorderSide(color: Colors.grey.shade300)
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text(
                                'Geriyə',
                                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
  void forgotInit()async{
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      final registerInit = await AuthService.ForgotInit(_emailController.text);
      setState(() { _isLoading = false; });
      if (registerInit == "") {
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.pushNamed(context, '/forgotOTP', arguments: _emailController.text);
        }
      } else {
        setState(() {
          final Map<String, dynamic> responseData = jsonDecode(registerInit);

          if (responseData.containsKey('error')) {
            errorText = responseData['error'].toString();

          } else {
            errorText = "Xəta baş verdi, zəhmət olmasa yenidən yoxlayın.";
          }
        });
        Future.delayed(Duration(seconds: 2),(){
          setState(() {
            errorText='';
          });
        });
      }
    }
  }
}
