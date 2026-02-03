import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:media_radar/views/forgots/ForgotPass.dart';

import '../../constants/Constant.dart';
import '../../services/AuthService.dart';
class ForgotOTP extends StatefulWidget {
  final  String email;
  const ForgotOTP({required this.email,super.key});

  @override
  State<ForgotOTP> createState() => _ForgotOTPState();
}

class _ForgotOTPState extends State<ForgotOTP> {
  String currentOtp = '';
  String errorCode = '';
  bool isLoading = false;

  void checkOtpForgot() async {
    if (currentOtp.length < 6) {
      setState(() {
        errorCode = "Kodu tam daxil edin";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorCode = '';
    });

    final response = await AuthService.forgotOtp(widget.email, currentOtp);

    if (response == "") {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ForgotPass(email: widget.email)),
              (route) => false,
        );
      }
    } else {
      setState(() {
        isLoading = false;
        try {
          final Map<String, dynamic> data = jsonDecode(response);
          errorCode = 'Kodu düzgün daxil edin!';
        } catch (e) {
          errorCode = response;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/MediaRadar_logo_png.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Text(
                //   '',
                //   style: TextStyle(
                //     fontSize: 24,
                //     color: Constant.baseColor,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                const SizedBox(height: 15),
                Text(
                  'E-mail adresinizə göndərilmiş 6 rəqəmli\n kodu daxil edin',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF525866),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 50),
                if (errorCode.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      errorCode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: errorCode.isNotEmpty ? Colors.red : const Color(0xFFE0E0E0),
                  focusedBorderColor: errorCode.isNotEmpty ? Colors.red : Constant.baseColor,
                  showFieldAsBox: true,
                  fieldWidth: 45,
                  borderRadius: BorderRadius.circular(12.0),
                  borderWidth: 2.5,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Constant.baseColor,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
                  cursorColor: Constant.baseColor,
                  onCodeChanged: (String code) {
                    currentOtp = code;
                  },
                  onSubmit: (String verificationCode) {
                    setState(() {
                      currentOtp = verificationCode;
                    });
                    checkOtpForgot();
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.baseColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isLoading ? null : checkOtpForgot,
                    child: isLoading
                        ?  SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        :  Text(
                      'Növbəti',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Geriyə',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
