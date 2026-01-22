import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final List<Map<String, dynamic>> moreOptions = [
    {'icon': Icons.apps_outlined, 'name': 'Kateqoriyalar'},
    {'icon': Icons.notifications_none_rounded, 'name': 'Bildirişlər'},
    {'icon': Icons.search, 'name': 'Ətraflı axtarış'},
    {'icon': Icons.language, 'name': 'Dil seçimi'},

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'Parametrler',
                style: TextStyle(
                  color: Constant.baseColor,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Hesab Card
              Card(
                elevation: 0.4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 5,right: 5),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/images.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'Hesab',
                    style: TextStyle(
                      fontSize: 14,
                      color: Constant.inputHintTextColor,
                    ),
                  ),
                  subtitle: const Text(
                    'Leyla',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.keyboard_arrow_right_rounded,color: Color(0xFFADADAD),),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Column(
                  children: moreOptions.map<Widget>((x) {
                    // Disabled elementi grey etmək üçün
                    bool isDisabled = x['name'] == 'Bildirişlər' || x['name'] == 'Ətraflı axtarış';
                    Color textColor = isDisabled ? Constant.inputHintTextColor : Colors.black;
                    Color iconColor = isDisabled ? Constant.inputHintTextColor : Colors.black;

                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            x['icon'],
                            color: iconColor,
                          ),
                          title: Text(
                            x['name'],
                            style: TextStyle(color: textColor),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Color(0xFFADADAD),
                          ),
                          onTap: isDisabled
                              ? null
                              : () {

                          },
                        ),
                        Divider(height: 1, color: Constant.inputBorderColor),
                      ],
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20,),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Çıxış',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded,color: Color(0xFFADADAD),),
                  onTap: () {
                    // Burada click funksiyasını yaz
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
