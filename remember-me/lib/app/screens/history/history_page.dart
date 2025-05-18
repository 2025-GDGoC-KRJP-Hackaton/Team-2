import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/extension/datetime_x.dart';
import 'package:remember_me/app/screens/history/logic/history_provider.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
    ref.read(historyProvider.notifier).getHistories();
  }

  @override
  Widget build(BuildContext context) {
    final histories =
        [...ref.watch(historyProvider).histories].reversed.toList();
    return Scaffold(
      appBar: AppBar(title: Text("History")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('History', style: TextStyle(color: Colors.grey)),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  itemBuilder: (context, index) {
                    final history = histories[index];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text(history.created_at.formatDateTime()),
                          ),
                          if (history.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Text(history.text),
                            ),
                          if (history.image_url.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: history.image_url,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor: Colors.white,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.black,
                                          height: 200,
                                          width: 300,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemCount: histories.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
