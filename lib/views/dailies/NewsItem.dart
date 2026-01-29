import 'package:flutter/material.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:provider/provider.dart';

class NewsItem extends StatefulWidget {
  final String? image;
  final String? title;
  final String? text;
  final String date;
  final bool? isSaved;
  final String id;
  final String? descFull;

  const NewsItem({
    super.key,
    this.image,
    this.descFull,
    this.isSaved,
    this.title,
    this.text,
    required this.id,
    required this.date,
  });

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return "";
    try {
      return rawDate.split('.').first;
    } catch (e) {
      return rawDate;
    }
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty || url.toLowerCase() == "null") return false;
    return url.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: !widget.isSaved!
                ? const Icon(Icons.bookmark_border, color: Colors.white)
                : const Icon(Icons.bookmark, color: Colors.amber),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.id,
              child: Stack(
                children: [
                  _isValidUrl(widget.image)
                      ? Image.network(
                    widget.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
                  )
                      : _buildErrorPlaceholder(),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(
                          "Gündəm",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        _formatDate(widget.date),
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Text(
                    widget.title ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),

                  Text(
                    widget.text ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: 350,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}