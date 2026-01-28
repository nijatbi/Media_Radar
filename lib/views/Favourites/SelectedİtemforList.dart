import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/AuthService.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import '../../models/New.dart';

class SelectedItemForList extends StatefulWidget {
  final News? news;
  const SelectedItemForList({this.news, super.key});

  @override
  State<SelectedItemForList> createState() => _SelectedItemForListState();
}

class _SelectedItemForListState extends State<SelectedItemForList> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void _loadToken() async {
    final token = await SecureStorageService.getToken();
    if (mounted) {
      setState(() {
        _token = token;
      });
    }
  }

  String formatDate(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy – HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  String _buildImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    return "${AuthService.baseUrl}/tg/get_image_by_filename?filename=${Uri.encodeComponent(path)}";
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final isTelegram = newsProvider.statucCode != 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: _buildMainImage(isTelegram),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildChannelAvatar(isTelegram),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.news?.domain ?? '',
                        style: const TextStyle(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.news?.isSaved ?? false)
                      const Icon(Icons.bookmark, size: 20, color: Color(0xFFF66F6A)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  (context.watch<NewsProvider>().statucCode != 1)
                      ? ((widget.news?.text ?? "").length > 35
                      ? "${widget.news!.text!.substring(0, 35)}..."
                      : (widget.news?.title ?? ""))
                      : (widget.news?.title ?? ""),

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(widget.news?.scrapedAt?.toString() ?? ''),
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage(bool isTelegram) {
    if (isTelegram) {
      if (_token == null) return const Center(child: CupertinoActivityIndicator());
      return Image.network(
        _buildImageUrl(widget.news?.imageUrl),
        headers: {'Authorization': "Bearer $_token"},
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else {
      return Image.network(
        widget.news?.imageUrl ?? '',
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }

  Widget _buildChannelAvatar(bool isTelegram) {
    if (isTelegram && widget.news?.channelImage != null && _token != null) {
      return ClipOval(
        child: Image.network(
          _buildImageUrl(widget.news?.channelImage),
          headers: {'Authorization': "Bearer $_token"},
          width: 20,
          height: 20,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.account_circle, size: 20),
        ),
      );
    }
    return const Icon(Icons.account_circle, size: 20, color: Colors.grey);
  }
}