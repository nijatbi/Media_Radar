import 'package:flutter/material.dart';
class Constant{
  static Color baseColor = Color(0xFF3F3BA3);
  static Color inputBorderColor=Color(0xFFE2E4E9);
  static const Color inputHintTextColor = Color(0xFF868C98);
  static Color checkBoxBorderColor=Color(0xFFADADAD);
  static Text loginText1=Text('Hesabınıza giriş edin',style: TextStyle(fontSize: 24,color: Constant.baseColor,fontWeight: FontWeight.w500,),);
  static Text loginText2=Text('Zəhmət olmasa giriş məlumatlarınızı daxil edin',style: TextStyle(fontSize: 14,color: const Color(0xFF525866)),);
  static Text forgotPaswordText=Text('Şifrəni unutmusan?',style: TextStyle(fontSize: 14,color: Constant.forgotPasColor));
  static Color forgotPasColor=Color(0xFF1579FF);
  static Color languageAlertColor=Color(0xFF007AFF);
  static Color keyTextBackColor=Color(0xFFECEBFF);
}