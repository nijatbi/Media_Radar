import 'package:flutter/material.dart';

import '../../constants/Constant.dart';
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorText = '';
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
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
                Text('Qeydiyyatdan keçin',style: TextStyle(fontSize: 24,color: Constant.baseColor,fontWeight: FontWeight.w500,),),
                  const SizedBox(height: 10),
               Text('Zəhmət olmasa məlumatlarınızı daxil edin',style: TextStyle(fontSize: 14,color: const Color(0xFF525866)),),
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
                         Text(
                          'İstifadəçi adı',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                         SizedBox(height: 10),
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
                        Text(
                          'İstifadəçi Soyadı',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),


                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "İstifadəçi soyadı",
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
                              ? 'İstifadəçi soyadı doldur'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'İstifadəçi username',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "İstifadəçi username",
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
                              ? 'İstifadəçi username doldur'
                              : null,
                        ),



                        const SizedBox(height: 20),
                        Text(
                          'İstifadəçi username',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "İstifadəçi username",
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
                              ? 'İstifadəçi username doldur'
                              : null,
                        ),

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


                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constant.baseColor,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),

                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed:(){
                              Navigator.pushNamed(context, '/register');
                            },
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.blue)
                                : const Text(
                              'Qeydiyyatdan keç',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              elevation: 8,
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, '/login');
                            },
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Login',
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
        ),
      ),
    );
  }
}
