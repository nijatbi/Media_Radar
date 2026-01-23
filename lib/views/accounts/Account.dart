import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/views/accounts/Profile.dart';

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

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Dil seçimi',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3C3C4399),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 1),
                    ListTile(
                      title:  Center(child: Text('Azərbaycan',style: TextStyle(
                          fontSize: 20,

                          fontWeight:FontWeight.w500 ,color: Constant.languageAlertColor),)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1, thickness: 1),
                    ListTile(
                      title:  Center(child: Text('İngilis',style: TextStyle(
                          fontSize: 20,
                          fontWeight:FontWeight.w500 ,color: Constant.languageAlertColor
                      ),)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1, thickness: 1),
                    ListTile(
                      title: const Center(
                        child: Text('Ləğv et', style: TextStyle(color: Colors.red)),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


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

              Card(
                elevation: 0.4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 5, right: 5),
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
                      style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Color(0xFFADADAD),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Column(
                  children: moreOptions.map<Widget>((x) {
                    bool isDisabled = x['name'] == 'Bildirişlər' ||
                        x['name'] == 'Ətraflı axtarış';
                    Color textColor =
                    isDisabled ? Constant.inputHintTextColor : Colors.black;
                    Color iconColor =
                    isDisabled ? Constant.inputHintTextColor : Colors.black;

                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            x['icon'],
                            color: iconColor,
                          ),
                          title: Text(
                            x['name'],
                            style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Color(0xFFADADAD),
                          ),
                          onTap: isDisabled
                              ? null
                              : () {
                            if (x['name'] == 'Dil seçimi') {
                              _showLanguageBottomSheet();
                            }
                          },
                        ),
                        Divider(height: 1, color: Constant.inputBorderColor),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Çıxış',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color(0xFFADADAD),
                  ),
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
