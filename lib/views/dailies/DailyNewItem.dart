import 'package:flutter/material.dart';

import '../../constants/Constant.dart';
import 'NewsItem.dart';
class DailyNewItem extends StatefulWidget {
  final String image;
  final String title;
  final String desc;
  final String date;
  final String id;
  const DailyNewItem({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    required this.id,
    required this.date,
  });


  @override
  State<DailyNewItem> createState() => _DailyNewItemState();
}

class _DailyNewItemState extends State<DailyNewItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewsItem(
                  image: widget.image!,
                  title: widget.title!,
                  id: widget.id!,
                  desc: widget.desc!,
                  date: widget.date!,

                ),
              ),
            );
          },
          child: Hero(
            tag: widget.id,
            child: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                image:  DecorationImage(
                  image: AssetImage('${widget.image!}'),
                  fit: BoxFit.cover ,
                  colorFilter: ColorFilter.mode(
                    Colors.black26,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
        ),


        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.policy, size: 17),
                SizedBox(width: 4),
                Text(
                  'Siyasət',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 40,
          left: 14,
          right: 14,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(2), // 🔥 iç boşluq
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(150)),
                        child: Image.asset(
                          'assets/images/Rectangle 299.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                     Expanded(
                      child: Text(
                        '${widget.title!}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Flexible(
                  child: Text(
                    '${widget.desc}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${widget.date}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Constant.inputBorderColor,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
