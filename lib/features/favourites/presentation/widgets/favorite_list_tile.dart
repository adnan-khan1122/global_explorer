import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/favorite_country_summary.dart';

class FavoriteListTile extends StatelessWidget {
  const FavoriteListTile({
    super.key,
    required this.summary,
    required this.onTap,
  });

  final FavoriteCountrySummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: summary.flagPng != null && summary.flagPng!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: summary.flagPng!,
                width: 40,
                height: 28,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.flag_outlined),
              )
            : const Icon(Icons.flag_outlined),
      ),
      title: Text(summary.nameCommon),
      subtitle: Text(summary.region ?? ''),
      onTap: onTap,
    );
  }
}
