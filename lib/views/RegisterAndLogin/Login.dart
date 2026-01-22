import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); // ikinci input
  bool _obsureText=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0), // kənarlardan padding
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('İstifadəçi adı',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: InputDecoration(
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
                            color: Constant.inputBorderColor, // boz rəng
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('Şifrə',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),

                    TextFormField(
                      obscureText: _obsureText, // bu, şifrəni noqtələrlə göstərir
                      controller: passwordController,
                      decoration: InputDecoration(
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
                            color: Constant.checkBoxBorderColor, // border rəngi
                            width: 2,
                          ),
                          checkColor: Constant.forgotPasColor, // tick işarəsinin rəngi
                          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.selected)) {
                              return Constant.inputBorderColor; // seçiləndə doldurma rəngi
                            }
                            return Colors.white; // seçilməyibdirsə background
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
                          onPressed: (){}, child: Text('Login',style: TextStyle(fontSize: 16,color: Colors.white),)),
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
}
