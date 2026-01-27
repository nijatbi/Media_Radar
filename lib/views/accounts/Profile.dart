import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthProvider.dart';

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
      final authProvider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );
      await authProvider.getCurrentUser();

    });
  }

  void _openPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Şifrənin dəyişdirilməsi',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'İmtina et',
                            style:
                            TextStyle(fontSize: 15, color: Constant.baseColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cari Şifrə',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),

                          /// Cari şifrə input
                          TextFormField(
                            obscureText: _obscureOld,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              hintText: "••••••••",
                              hintStyle: TextStyle(color: Constant.inputHintTextColor),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Constant.inputBorderColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Constant.inputBorderColor, width: 1),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureOld
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  modalSetState(() {
                                    _obscureOld = !_obscureOld;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text('Yeni Şifrə',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),

                          TextFormField(
                            obscureText: _obscureNew,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              hintText: "••••••••",
                              hintStyle: TextStyle(color: Constant.inputHintTextColor),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Constant.inputBorderColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Constant.inputBorderColor, width: 1),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNew
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  modalSetState(() {
                                    _obscureNew = !_obscureNew;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                      SizedBox(height: 20,),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.baseColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text('Təsdiqlə',
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider?>()?.user;
    final authProvider = context.watch<AuthProvider>();
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'Hesab',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 17,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/profile-42914_640.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Şəkli dəyiş",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Constant.forgotPasColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 40),

            personInfo(user?.name ?? '', 'Ad'),
              const SizedBox(height: 20),
            personInfo(user?.surname ?? '', 'Soyad'),
              const SizedBox(height: 20),
          personInfo(user?.userName ?? '', 'İstifadəçi adı'),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Şifrə',
                      style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _openPasswordModal(context),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Şifrəni dəyiş',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Constant.baseColor,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Constant.checkBoxBorderColor,
                            ),
                          ],
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
    );
  }

  Widget personInfo(String info, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(info,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Icon(Icons.keyboard_arrow_right,
                    color: Constant.checkBoxBorderColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
