import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import '../../constants/Constant.dart';

void addCategoryAppBar(BuildContext context) {
  final TextEditingController categoryCtrl = TextEditingController();
  final TextEditingController keywordCtrl = TextEditingController();
  List<String> keywords = [];
  var _formKey = GlobalKey<FormState>();
  bool showAddIcon = false;
  String erorText='';
  Widget _buildTag(String text, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Constant.keyTextBackColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.clear, color: Colors.white, size: 13),
            ),
          ),
        ],
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, modalSetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            width: 80,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Yeni kateqoriya',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'İmtina et',
                                style: TextStyle(
                                    fontSize: 15, color: Constant.baseColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              erorText!="" ? Text(erorText,style: TextStyle(fontSize: 12,color: Colors.red),) :SizedBox.shrink(),
                              Row(
                                children: const [
                                  Icon(Icons.layers),
                                  SizedBox(width: 5),
                                  Text('Kateqoriya adı',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: categoryCtrl,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                  if(value=="" || value!.length==0){
                                    return 'Category adını doldur';
                                  }else return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  hintText: "Placeholder text...",
                                  errorStyle: TextStyle(fontSize: 12,color: Colors.red),
                                  hintStyle: TextStyle(
                                      color: Constant.inputHintTextColor),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Constant.inputBorderColor,
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Constant.inputBorderColor,
                                        width: 1),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('Açar sözlər',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: keywordCtrl,

                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  modalSetState(() {
                                    showAddIcon = value.trim().length >= 3;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(fontSize: 12,color: Colors.red),
                                  suffixIcon: showAddIcon
                                      ? IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Color(0xFF3F3BA3)),
                                    onPressed: () {
                                      if (keywordCtrl.text.trim().isEmpty) {
                                        return;
                                      }
                                      modalSetState(() {
                                        keywords.add(keywordCtrl.text.trim());
                                        keywordCtrl.clear();
                                        showAddIcon = false;
                                      });
                                    },
                                  )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  hintText: "Placeholder text...",
                                  hintStyle: TextStyle(
                                      color: Constant.inputHintTextColor),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Constant.inputBorderColor,
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Constant.inputBorderColor,
                                        width: 1),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: keywords
                              .map((keyword) => _buildTag(keyword, () {
                            modalSetState(() {
                              keywords.remove(keyword);
                            });
                          }))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(keywords.length==0){
                            modalSetState((){
                              erorText='Açar söz əlavə et';
                            });
                            return ;
                          }
                          else if(_formKey.currentState!.validate()){
                            final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                            if (categoryCtrl.text.trim().isEmpty) return;

                            await authProvider.addStreamToUser(
                                categoryCtrl.text.trim(), keywords, context);

                            Navigator.pop(context);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.baseColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text(
                          'Təsdiqlə',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
