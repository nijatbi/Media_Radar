import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import 'package:media_radar/views/HomePages/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String erorText='';
  var _formKey = GlobalKey<FormState>();
  bool _obsureText=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
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
              const SizedBox(height: 20),
              Constant.loginText2,
              const SizedBox(height: 50),

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${erorText}',style: TextStyle(
                      fontSize: 12,color: Colors.red,fontWeight: FontWeight.w500
                    ),),
                    SizedBox(height: 10,),
                    Text('İstifadəçi adı',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: usernameController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red,fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        hintText: "İstifadəçi adı",
                        hintStyle: TextStyle(color: Constant.inputHintTextColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Constant.inputBorderColor, // boz rəng
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Constant.inputBorderColor,
                            width: 1,
                          ),
                        ),
                      ),

                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'İstifadəçi adını doldur';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    Text('Şifrə',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),

                    TextFormField(
                      obscureText: _obsureText, //
                      controller: passwordController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 12,color: Colors.red),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        hintText: "Şifrə", // hint text
                        hintStyle: TextStyle(color: Constant.inputHintTextColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Constant.inputBorderColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Constant.inputBorderColor,
                            width: 1,
                          ),
                        ),
                        suffixIcon: Container(
                          width: 40,
                          child: IconButton(onPressed: (){
                            setState(() {
                              _obsureText=!_obsureText;
                            });
                          }, icon: Icon(_obsureText ? Icons.visibility: Icons.visibility_off)),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Constant.inputHintTextColor)
                            )
                          ),
                        )
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Şifrəni doldur';
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                          side: BorderSide(
                            color: Constant.checkBoxBorderColor,
                            width: 2,
                          ),
                          checkColor: Constant.forgotPasColor,
                          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.selected)) {
                              return Constant.inputBorderColor;
                            }
                            return Colors.white;
                          }),
                        ),
                       Constant.forgotPaswordText,

                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Constant.baseColor,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.baseColor
                          ),
                          onPressed: (){
                            loginProcess();
                          }, child: Text('Login',style: TextStyle(fontSize: 16,color: Colors.white),)),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void loginProcess() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await AuthService.login(
          usernameController.text,
          passwordController.text,
        );
        final Map<String, dynamic> data = jsonDecode(response);
        if (response.contains('access_token')) {
          await SecureStorageService.saveToken(data["access_token"]);
          await SecureStorageService.getToken();
          Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));

        } else {
          setState(() {
            erorText = data['error'] ?? 'Xəta baş verdi';
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              erorText = '';
            });
          });
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xəta: $e')),
        );
      }
    }
  }

}
