import 'package:flutter/material.dart';
class NewsItem extends StatefulWidget {
  final String image;
  final String title;
  final String desc;
  final String date;
  final String id;
  const NewsItem({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    required this.id,
    required this.date,
  });

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Hero(
            tag: widget.id,

            child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              widget.image!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.desc,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.date,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
