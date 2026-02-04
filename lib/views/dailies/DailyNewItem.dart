import 'package:flutter/material.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import 'package:provider/provider.dart';
import '../../services/NewsService.dart';
import 'NewsItem.dart';

class DailyNewItem extends StatefulWidget {
  final String imageUrl;
  final String coverImage;
  final String title;
  final String? desc;
  final String? descFull;
  final String? domainName;
  final String date;
  final bool? isSaved;
  final int id;
  final List<News>? similiarNews;
  final String? categoryName;

  const DailyNewItem({
    super.key,
    this.similiarNews,
    this.categoryName,
    this.descFull,
    required this.imageUrl,
    required this.coverImage,
    this.domainName,
     this.isSaved,
    required this.title,
    this.desc,
    required this.id,
    required this.date,
  });

  @override
  State<DailyNewItem> createState() => _DailyNewItemState();
}

class _DailyNewItemState extends State<DailyNewItem> {
  String? finalImageUrl;
  String? finalCoverUrl;
  String? tokenAuth;
  bool isImageReady = false;

  @override
  void initState() {
    super.initState();
    loadImagesandToken();
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final lower = url.toLowerCase();
    if (lower == "null" || lower.contains("file:///null")) return false;
    return lower.startsWith('http');
  }

  Future<void> loadImagesandToken() async {
    try {
      final token = await SecureStorageService.getToken();
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);

      String? imgUrl;
      if (newsProvider.statucCode == 1) {
        imgUrl = widget.imageUrl;
      } else {
        imgUrl = await NewsService.buildImageUrl(widget.imageUrl);
      }

      if (imgUrl != null && imgUrl.toLowerCase().endsWith('.svg')) {
        imgUrl = null;
      }

      final coverUrl = await NewsService.buildImageUrl(widget.coverImage);

      if (mounted) {
        setState(() {
          tokenAuth = token;
          finalCoverUrl = _isValidUrl(coverUrl) ? coverUrl : null;
        });

        if (_isValidUrl(imgUrl)) {
          final ImageProvider netImage = NetworkImage(
            imgUrl!,
            headers: {if (token != null) 'Authorization': 'Bearer $token'},
          );

          precacheImage(netImage, context).then((_) {
            if (mounted) {
              setState(() {
                finalImageUrl = imgUrl;
                isImageReady = true;
              });
            }
          }).catchError((e) {
            debugPrint("Precache xətası: $e");
            if (mounted) setState(() => isImageReady = false);
          });
        } else {
          if (mounted) setState(() => isImageReady = false);
        }
      }
    } catch (e) {
      debugPrint("Yükləmə xətası: $e");
    }
  }

  String domainImageUrl(String domain) {
    String cleanDomain = domain.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
    return 'https://www.google.com/s2/favicons?domain=$cleanDomain&sz=64';
  }
  @override
  Widget build(BuildContext context) {
    final Map<String, String> headers = {
      if (tokenAuth != null && tokenAuth!.isNotEmpty)
        'Authorization': 'Bearer $tokenAuth',
    };

    return GestureDetector(
      onTap: ()async {
        final similiarNews=await NewsService.getSimiliarsNews(widget.id!);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsItem(
              image: finalImageUrl ?? widget.imageUrl,
              title: widget.title,
              id: widget.id,
              text: widget.desc ?? "",
              categoryName: widget.categoryName ?? 'Gündəm',
              isSaved: widget.isSaved,
              similiarNews: similiarNews ?? [],
              date: widget.date,
            ),
          ),
        );
      },
      child: Hero(
        tag: widget.id,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0xFFD1D1D1),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isImageReady && finalImageUrl != null)
                Image.network(
                  finalImageUrl!,
                  headers: headers,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),

                )
              else
                _buildErrorPlaceholder(),

              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black38],
                  ),
                ),
              ),

              Positioned(top: 12, left: 12, child: _buildCategoryBadge()),

              Positioned(bottom: 40, left: 14, right: 14, child: _buildBottomContent(headers)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 30),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        widget.categoryName ?? 'Siyasət',
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            decoration: TextDecoration.none
        ),
      ),
    );
  }

  Widget _buildBottomContent(Map<String, String> headers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: _isValidUrl(widget.domainName) || (widget.domainName != null && widget.domainName!.isNotEmpty)
                    ? Image.network(
                  domainImageUrl(widget.domainName!),
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) {
                    debugPrint("Favicon error: $e");
                    return const Icon(Icons.public, size: 15, color: Colors.grey);
                  },
                )
                    : const Icon(Icons.person, size: 15, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.domainName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.none
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.desc ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.date,
          style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
              decoration: TextDecoration.none
          ),
        ),
      ],
    );
  }
}