import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constants/Constant.dart';
class AppBarAlert extends StatefulWidget {
  final bool showMenu;
  final Function(String)? onSelect;
  const AppBarAlert({required this.showMenu,this.onSelect,super.key});

  @override
  State<AppBarAlert> createState() => _AppBarAlertState();
}

class _AppBarAlertState extends State<AppBarAlert> {

  List<String> secimler=['Seçilmiş mənbə',"Aktiv kateqoriyalar","Tarix"];

  @override
  Widget build(BuildContext context) {
    if (!widget.showMenu) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 350,
          ),
          child: IntrinsicWidth(
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _menuItem(Icons.verified_outlined, 'Seçilmiş mənbə'),
                  _divider(),
                  _menuItem(Icons.layers, 'Aktiv kateqoriyalar'),
                  _divider(),
                  _menuItem(Icons.calendar_month_outlined, 'Tarix'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return GestureDetector(
      onTap: (){
        if (widget.onSelect != null) widget.onSelect!(title);

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${title}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
            Icon(icon)
          ],
        ),
      ),
    );
  }
  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE0E0E0),
    );
  }

}
